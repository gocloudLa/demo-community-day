module "project_core" {

  source = "../../../../wrappers/project/"

  /*----------------------------------------------------------------------*/
  /* General Variables                                                    */
  /*----------------------------------------------------------------------*/

  metadata = local.metadata
  project  = "core"

  /*----------------------------------------------------------------------*/
  /* ALB Variables                                                        */
  /*----------------------------------------------------------------------*/
  alb_parameters = {
    "external-00" = {
      subnets  = data.aws_subnets.public.ids
      internal = false
      http_tcp_listeners = [
        {
          port        = 80
          protocol    = "HTTP"
          action_type = "redirect"
          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            host        = "#{host}"
            path        = "/#{path}"
            query       = "#{query}"
          }
        }
      ]
      https_listeners = [
        {
          port            = 443
          protocol        = "HTTPS"
          certificate_arn = data.aws_acm_certificate.this.arn
          action_type     = "fixed-response"
          fixed_response = {
            content_type = "text/plain"
            message_body = "Fixed message"
            status_code  = "200"
          }
        }
      ]
      ingress_with_cidr_blocks = [
        {
          rule        = "http-80-tcp"
          cidr_blocks = "0.0.0.0/0"
          description = "Enable all access"
        },
        {
          rule        = "https-443-tcp"
          cidr_blocks = "0.0.0.0/0"
          description = "Enable all access"
        }
      ]
    }
  }

  /*----------------------------------------------------------------------*/
  /* RDS Variables                                                        */
  /*----------------------------------------------------------------------*/
  rds_parameters = {
    "mysql-00" = {
      engine_version       = "8.0.37"
      major_engine_version = "8.0"
      engine               = "mysql"
      family               = "mysql8.0"
      subnet_ids           = data.aws_subnets.private.ids

      # DEBUG
      deletion_protection = false
      apply_immediately   = true
      skip_final_snapshot = true

      dns_records = {
        "" = {
          zone_name    = local.zone_private
          private_zone = true
        }
      }

      ingress_with_cidr_blocks = [
        {
          rule        = "mysql-tcp"
          cidr_blocks = data.aws_vpc.this.cidr_block
        }
      ]

      maintenance_window      = "Sun:04:00-Sun:06:00"
      backup_window           = "03:00-03:30"
      backup_retention_period = "7"
      apply_immediately       = true

      # DB MANAGEMENT
      enable_db_management                    = false
      enable_db_management_logs_notifications = false
    }
  }

  /*----------------------------------------------------------------------*/
  /* ECS Variables                                                        */
  /*----------------------------------------------------------------------*/
  ecs_parameters = {
    "00" = {
      cluster_settings = {
        name  = "containerInsights"
        value = "disabled"
      }
      cluster_configuration = {
        execute_command_configuration = {
          logging = "DEFAULT"
        }
      }
      default_capacity_provider_use_fargate = true
      fargate_capacity_providers = {
        FARGATE = {
          default_capacity_provider_strategy = {
            weight = 00
          }
        }
        FARGATE_SPOT = {
          default_capacity_provider_strategy = {
            weight = 100
          }
        }
      }
      autoscaling_capacity_providers = {}
    }
  }

  /*----------------------------------------------------------------------*/
  /* BUCKET Variables                                                     */
  /*----------------------------------------------------------------------*/
  bucket_parameters = {
    "storage" = {
      create_bucket                 = true
      enable_s3_public_access_block = false
      block_public_acls             = true
      block_public_policy           = true
      ignore_public_acls            = true
      restrict_public_buckets       = true
      object_ownership              = "BucketOwnerEnforced"
    }
  }
}