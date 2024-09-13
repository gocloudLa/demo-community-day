module "wrapper_rds" {
  source = "../../"

  metadata = local.metadata
  project  = local.project

  rds_parameters = {
    "mariadb-00" = {

      engine_version = "10.6.14"
      # DEBUG
      deletion_protection = false
      apply_immediately   = true
      skip_final_snapshot = true

      subnet_ids          = data.aws_subnets.public.ids
      publicly_accessible = true
      ingress_with_cidr_blocks = [
        {
          rule        = "mysql-tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]

      dns_records = {
        "" = {
          # zone_name    = local.zone_private
          # private_zone = true
          # DEBUG
          zone_name    = local.zone_public
          private_zone = false
        }
      }
      parameters = [
        {
          name  = "max_connections"
          value = "150"
        }
      ]
      maintenance_window      = "Sun:04:00-Sun:06:00"
      backup_window           = "03:00-03:30"
      backup_retention_period = "7"
      apply_immediately       = true

    }

    "pgsql-00" = {

      engine               = "postgres"
      engine_version       = "15"
      family               = "postgres15" # DB parameter group
      major_engine_version = "15"         # DB option group

      port = "5432"

      # DEBUG
      deletion_protection = false
      apply_immediately   = true
      skip_final_snapshot = true

      subnet_ids          = data.aws_subnets.public.ids
      publicly_accessible = true
      ingress_with_cidr_blocks = [
        {
          rule        = "postgresql-tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]

      dns_records = {
        "" = {
          # zone_name    = local.zone_private
          # private_zone = true
          # DEBUG
          zone_name    = local.zone_public
          private_zone = false
        }
      }
      # parameters = [
      #   {
      #     name  = "max_connections"
      #     value = "150"
      #   }
      # ]
      maintenance_window      = "Sun:04:00-Sun:06:00"
      backup_window           = "03:00-03:30"
      backup_retention_period = "7"
      apply_immediately       = true
    }
    "mysql-00" = {

      engine_version       = "8.0.37"
      major_engine_version = "8.0"
      engine               = "mysql"
      family               = "mysql8.0"
      # DEBUG
      deletion_protection = false
      subnet_ids          = data.aws_subnets.private.ids
      publicly_accessible = false
      ingress_with_cidr_blocks = [
        {
          rule        = "mysql-tcp"
          cidr_blocks = "0.0.0.0/0"
        }
      ]

      dns_records = {
        "" = {
          zone_name    = local.zone_private
          private_zone = true
        }
      }

      db_parameter_group_parameters = [
        {
          name         = "connect_timeout"
          value        = 120
          apply_method = "immediate"
          }, {
          name         = "general_log"
          value        = 0
          apply_method = "immediate"
          }, {
          name         = "innodb_lock_wait_timeout"
          value        = 300
          apply_method = "immediate"
          }, {
          name         = "log_output"
          value        = "FILE"
          apply_method = "pending-reboot"
          }, {
          name         = "long_query_time"
          value        = 5
          apply_method = "immediate"
          }, {
          name         = "max_connections"
          value        = 150
          apply_method = "immediate"
          }, {
          name         = "slow_query_log"
          value        = 1
          apply_method = "immediate"
          }, {
          name         = "log_bin_trust_function_creators"
          value        = 1
          apply_method = "immediate"
        }
      ]

      # Monitoring & logs
      enabled_cloudwatch_logs_exports = ["error", "slowquery"]

      maintenance_window      = "Sun:04:00-Sun:06:00"
      backup_window           = "03:00-03:30"
      backup_retention_period = "7"
      apply_immediately       = true
    }

    rds_defaults = var.rds_defaults
  }
}