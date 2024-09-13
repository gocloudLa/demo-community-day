module "wrapper_workload" {

  source = "../../../../wrappers/workload"

  providers = {
    aws.use1 = aws.use1
  }

  /*----------------------------------------------------------------------*/
  /* General Variables                                                    */
  /*----------------------------------------------------------------------*/

  metadata = local.metadata

  /*----------------------------------------------------------------------*/
  /* ECS Service Parameters                                               */
  /*----------------------------------------------------------------------*/
  ecs_service_parameters = {
    "blog" = {
      enable_autoscaling = false

      cpu    = 256
      memory = 512

      health_check_grace_period_seconds = 60

      capacity_provider_strategy = [{
        base              = null
        capacity_provider = "FARGATE_SPOT"
        weight            = 100
      }]

      tasks_iam_role_statements = [
        {
          actions = [
            "s3:ListBucket",
            "s3:ListAllMyBuckets"
          ]
          resources = ["arn:aws:s3:::*"]
        },
        {
          actions = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:GetObjectVersion",
            "s3:GetBucketPolicy",
            "s3:GetBucketAcl",
            "s3:GetBucketVersioning",
            "s3:GetLifecycleConfiguration"
          ]
          resources = [data.aws_s3_bucket.storage.arn]
        }
      ]

      containers = {
        app = {
          image = "public.ecr.aws/bitnami/wordpress:latest"

          cloudwatch_log_group_retention_in_days = 30
          ports = {
            "port" = {
              container_port = 8080
              load_balancer = {
                alb_name             = data.aws_lb.external_alb.name
                alb_listener_port    = 443
                deregistration_delay = 30
                slow_start           = 60
                health_check = {
                  path    = "/"
                  matcher = 200
                }
                dns_records = {
                  "blog" = {
                    zone_name    = "${local.zone_public}"
                    private_zone = false
                  }
                }
                listener_rules = {
                  "rule1" = {
                    priority = 110
                    conditions = [
                      {
                        host_headers = ["blog.${local.zone_public}"]
                      }
                    ]
                  }
                }
              }
            }
          }
          map_environment = {
            "WORDPRESS_USERNAME"             = "demo"
            "WORDPRESS_PASSWORD"             = "demo123"
            "WORDPRESS_DATABASE_USER"        = local.db_user
            "WORDPRESS_DATABASE_PASSWORD"    = local.db_password
            "WORDPRESS_DATABASE_HOST"        = local.db_host
            "WORDPRESS_DATABASE_PORT_NUMBER" = local.db_port
            "WORDPRESS_DATABASE_NAME"        = "wordpress"
          }
        }
      }
    }

    # INSEGURO !! Only for Debug !!
    "dbadmin" = {
      enable_autoscaling     = false
      cpu                    = 512
      memory                 = 1024

      capacity_provider_strategy = [{
        base              = null
        capacity_provider = "FARGATE_SPOT"
        weight            = 100
      }]

      containers = {
        "app" = {
          image = "public.ecr.aws/docker/library/phpmyadmin"
          map_environment = {
            "PMA_HOSTS"        = local.db_host
            "PMA_ABSOLUTE_URI" = "https://dbadmin.${local.zone_public}"
            "UPLOAD_LIMIT"     = "300M"
            # Habilitar estas variables da acceso a la DB desde la URL sin Autenticacion
            # "PMA_USER"         = local.db_user
            # "PMA_PASSWORD"     = local.db_password
          }
          map_secrets = {}
          ports = {
            "port1" = {
              container_port = 80
              load_balancer = {
                alb_name = data.aws_lb.external_alb.name
                listener_rules = {
                  "rule1" = {
                    conditions = [
                      {
                        host_headers = ["dbadmin.${local.zone_public}"]
                      }
                    ]
                  }
                }
                dns_records = {
                  "dbadmin" = {
                    zone_name    = "${local.zone_public}"
                    private_zone = false
                  }
                }
              }
            }
          }
        }
      }
    }
  }

}
