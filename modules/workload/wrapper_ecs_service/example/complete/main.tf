module "wrapper_ecs_service" {

  source = "../../"

  /*----------------------------------------------------------------------*/
  /* General Variables                                                    */
  /*----------------------------------------------------------------------*/

  metadata = local.metadata

  /*----------------------------------------------------------------------*/
  /* ECS Service Parameters                                               */
  /*----------------------------------------------------------------------*/

  ecs_service_parameters = {
    ExSimpleEcr = {
      # vpc_name                               = "dmc-prd"          # (Opcional) Auto Descubrimiento
      # subnet_name                            = "dmc-prd-private*" # (Opcional) Auto Descubrimiento
      # ecs_cluster_name                       = "dmc-prd-core-00"  # (Opcional) Auto Descubrimiento

      enable_autoscaling     = false
      enable_execute_command = true

      capacity_provider_strategy = [{
        base              = null
        capacity_provider = "FARGATE_SPOT"
        weight            = 50
      }]

      # Policies que usan la tasks desde el codigo desarrollado
      tasks_iam_role_policies = {
        ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      }
      tasks_iam_role_statements = [
        {
          actions   = ["s3:List*"]
          resources = ["arn:aws:s3:::*"]
        }
      ]
      # Policies que usa el servicio para poder iniciar tasks (ecr / ssm / etc)
      task_exec_iam_role_policies = {}
      task_exec_iam_statements    = {}

      ecs_task_volume = []

      containers = {
        app = {
          cloudwatch_log_group_retention_in_days = 7
          readonly_root_filesystem               = false
          #repository_image_tag_mutability        = "IMMUTABLE"
          ports = {
            "port1" = {
              container_port = 80
              # host_port      = 80 # (Opcional)
              # protocol       = "tcp" # (Opcional)
              load_balancer = {
                alb_name = "dmc-prd-core-external-00"
                listener_rules = {
                  "rule1" = {
                    # priority          = 10
                    # actions = [{ type = "forward" }] # Default Action
                    conditions = [
                      {
                        host_headers = ["ExSimpleEcr.${local.zone_public}"]
                      }
                    ]
                  }
                }
              }
            }
          }
          map_environment = {
            "ENV_1" = "env_value_1"
            "ENV_1" = "env_value_2"
          }
        }
      }
    }

    ExPublicEcr = {
      # ecs_cluster_name                       = "dmc-prd-core-00"
      # vpc_name                               = "dmc-prd"
      # subnet_name                            = "dmc-prd-private*"
      enable_autoscaling = false

      enable_execute_command = true

      # Policies que usan la tasks desde el codigo desarrollado
      tasks_iam_role_policies   = {}
      tasks_iam_role_statements = {}
      # Policies que usa el servicio para poder iniciar tasks (ecr / ssm / etc)
      task_exec_iam_role_policies = {}
      task_exec_iam_statements    = {}


      ecs_task_volume = []

      containers = {
        app = {
          image                 = "public.ecr.aws/docker/library/nginx:latest"
          create_ecr_repository = false
          map_environment       = {}
          ports = {
            "port1" = {
              container_port = 80
              load_balancer = {
                alb_name = "dmc-prd-core-external-00"
                listener_rules = {
                  "rule1" = {
                    # priority          = 10
                    # actions = [{ type = "forward" }] # Default Action
                    conditions = [
                      {
                        host_headers = ["ExPublicEcr.${local.zone_public}"]
                      }
                    ]
                  }
                }
              }
            }
          }
        }
      }
    }

    ExAlbDns = {
      enable_autoscaling = false

      # Policies que usan la tasks desde el codigo desarrollado
      tasks_iam_role_policies   = {}
      tasks_iam_role_statements = {}
      # Policies que usa el servicio para poder iniciar tasks (ecr / ssm / etc)
      task_exec_iam_role_policies = {}
      task_exec_iam_statements    = {}

      ecs_task_volume = []

      containers = {
        app = {
          image                 = "public.ecr.aws/docker/library/nginx:latest"
          create_ecr_repository = false
          ports = {
            "port1" = {
              container_port = 80
              protocol       = "tcp"
              load_balancer = {
                alb_name          = "dmc-prd-core-external-00"
                alb_listener_port = 443
                dns_records = {
                  "ExDns" = {
                    zone_name    = "${local.zone_public}"
                    private_zone = false
                  }
                }
                listener_rules = {
                  "rule1" = {
                    conditions = [
                      {
                        host_headers = ["ExDns.${local.zone_public}"]
                      }
                    ]
                  }
                }
              }
            }
          }
          map_environment = {}
        }
      }
    }

  }
}