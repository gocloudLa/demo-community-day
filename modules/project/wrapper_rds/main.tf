module "rds" {
  for_each = var.rds_parameters
  source   = "terraform-aws-modules/rds/aws"
  version  = "5.2.3"

  identifier                     = "${local.common_name}-${each.key}"
  instance_use_identifier_prefix = try(each.value.instance_use_identifier_prefix, var.rds_defaults.instance_use_identifier_prefix, false)

  ## master user & password
  username               = try(each.value.username, var.rds_defaults.username, "root")
  create_random_password = false
  random_password_length = 0
  password               = random_password.this[each.key].result

  ## subnet group
  create_db_subnet_group          = try(each.value.create_db_subnet_group, var.rds_defaults.create_db_subnet_group, true)
  db_subnet_group_name            = try(each.value.db_subnet_group_name, var.rds_defaults.db_subnet_group_name, "${local.common_name}-${each.key}")
  db_subnet_group_use_name_prefix = try(each.value.db_subnet_group_use_name_prefix, var.rds_defaults.db_subnet_group_use_name_prefix, false)
  subnet_ids                      = try(each.value.subnet_ids, var.rds_defaults.subnet_ids, [])
  db_subnet_group_description     = try(each.value.db_subnet_group_description, var.rds_defaults.db_subnet_group_description, null)
  db_subnet_group_tags            = try(each.value.db_subnet_group_tags, var.rds_defaults.db_subnet_group_tags, {})

  ## parameter group
  create_db_parameter_group       = try(each.value.create_db_parameter_group, var.rds_defaults.create_db_parameter_group, true)
  parameter_group_name            = try(each.value.parameter_group_name, var.rds_defaults.parameter_group_name, "${local.common_name}-${each.key}")
  parameter_group_use_name_prefix = try(each.value.parameter_group_use_name_prefix, var.rds_defaults.parameter_group_use_name_prefix, false)
  family                          = try(each.value.family, var.rds_defaults.family, "mariadb10.6")
  parameters                      = try(each.value.parameters, var.rds_defaults.parameters, [])
  parameter_group_description     = try(each.value.parameter_group_description, var.rds_defaults.parameter_group_description, null)
  db_parameter_group_tags         = try(each.value.db_parameter_group_tags, var.rds_defaults.db_parameter_group_tags, {})

  ## option group
  create_db_option_group       = try(each.value.create_db_option_group, var.rds_defaults.create_db_option_group, true)
  option_group_name            = try(each.value.option_group_name, var.rds_defaults.option_group_name, "${local.common_name}-${each.key}")
  option_group_use_name_prefix = try(each.value.option_group_use_name_prefix, var.rds_defaults.option_group_use_name_prefix, false)
  major_engine_version         = try(each.value.major_engine_version, var.rds_defaults.major_engine_version, "10.6")
  options                      = try(each.value.options, var.rds_defaults.options, [])
  option_group_description     = try(each.value.option_group_description, var.rds_defaults.option_group_description, null)
  option_group_timeouts        = try(each.value.option_group_timeouts, var.rds_defaults.option_group_timeouts, {})
  db_option_group_tags         = try(each.value.db_option_group_tags, var.rds_defaults.db_option_group_tags, {})

  ## instance
  create_db_instance     = try(each.value.create_db_instance, var.rds_defaults.create_db_instance, true)
  engine                 = try(each.value.engine, var.rds_defaults.engine, "mariadb")
  engine_version         = try(each.value.engine_version, var.rds_defaults.engine_version, "10.6.11")
  instance_class         = try(each.value.instance_class, var.rds_defaults.instance_class, "db.t3.micro")
  port                   = try(each.value.port, var.rds_defaults.port, 3306)
  db_name                = try(each.value.db_name, var.rds_defaults.db_name, null)
  vpc_security_group_ids = [module.security_group_rds[each.key].security_group_id]
  network_type           = try(each.value.network_type, var.rds_defaults.network_type, null)
  availability_zone      = try(each.value.availability_zone, var.rds_defaults.availability_zone, null)
  multi_az               = try(each.value.multi_az, var.rds_defaults.multi_az, false)
  kms_key_id             = try(each.value.kms_key_id, var.rds_defaults.kms_key_id, null)
  ca_cert_identifier     = try(each.value.ca_cert_identifier, var.rds_defaults.ca_cert_identifier, null)
  publicly_accessible    = try(each.value.publicly_accessible, var.rds_defaults.publicly_accessible, false)
  deletion_protection    = try(each.value.deletion_protection, var.rds_defaults.deletion_protection, true)
  timeouts               = try(each.value.timeouts, var.rds_defaults.timeouts, {})
  snapshot_identifier    = try(each.value.snapshot_identifier, var.rds_defaults.snapshot_identifier, null)
  db_instance_tags       = try(each.value.db_instance_tags, var.rds_defaults.db_instance_tags, {})

  ## storage
  allocated_storage     = try(each.value.allocated_storage, var.rds_defaults.allocated_storage, 5)
  max_allocated_storage = try(each.value.max_allocated_storage, var.rds_defaults.max_allocated_storage, 10)
  storage_type          = try(each.value.storage_type, var.rds_defaults.storage_type, null)
  iops                  = try(each.value.iops, var.rds_defaults.iops, null)
  storage_throughput    = try(each.value.storage_throughput, var.rds_defaults.storage_throughput, null)
  storage_encrypted     = true

  ## authentication
  iam_database_authentication_enabled = try(each.value.iam_database_authentication_enabled, var.rds_defaults.iam_database_authentication_enabled, false)
  domain                              = try(each.value.domain, var.rds_defaults.domain, null)
  domain_iam_role_name                = try(each.value.domain_iam_role_name, var.rds_defaults.domain_iam_role_name, null)

  ## backup
  backup_retention_period          = try(each.value.backup_retention_period, var.rds_defaults.backup_retention_period, null)
  backup_window                    = try(each.value.backup_window, var.rds_defaults.backup_window, null)
  delete_automated_backups         = try(each.value.delete_automated_backups, var.rds_defaults.delete_automated_backups, true)
  restore_to_point_in_time         = try(each.value.restore_to_point_in_time, var.rds_defaults.restore_to_point_in_time, null)
  final_snapshot_identifier_prefix = try(each.value.final_snapshot_identifier_prefix, var.rds_defaults.final_snapshot_identifier_prefix, null)
  skip_final_snapshot              = try(each.value.skip_final_snapshot, var.rds_defaults.skip_final_snapshot, true)
  copy_tags_to_snapshot            = true

  ## maintenance
  maintenance_window          = try(each.value.maintenance_window, var.rds_defaults.maintenance_window, "Sun:04:00-Sun:06:00")
  allow_major_version_upgrade = try(each.value.allow_major_version_upgrade, var.rds_defaults.allow_major_version_upgrade, false)
  auto_minor_version_upgrade  = try(each.value.auto_minor_version_upgrade, var.rds_defaults.auto_minor_version_upgrade, true)
  apply_immediately           = try(each.value.apply_immediately, var.rds_defaults.apply_immediately, false)

  ## monitoring
  create_monitoring_role                 = try(each.value.create_monitoring_role, var.rds_defaults.create_monitoring_role, true)
  monitoring_role_arn                    = try(each.value.monitoring_role_arn, var.rds_defaults.monitoring_role_arn, null)
  monitoring_role_name                   = try(each.value.monitoring_role_name, var.rds_defaults.monitoring_role_name, "${local.common_name}-rds-monitoring-${each.key}")
  monitoring_role_use_name_prefix        = try(each.value.monitoring_role_use_name_prefix, var.rds_defaults.monitoring_role_use_name_prefix, false)
  monitoring_role_description            = try(each.value.monitoring_role_description, var.rds_defaults.monitoring_role_description, null)
  monitoring_interval                    = try(each.value.monitoring_interval, var.rds_defaults.monitoring_interval, 0)
  performance_insights_enabled           = try(each.value.performance_insights_enabled, var.rds_defaults.performance_insights_enabled, false)
  performance_insights_retention_period  = try(each.value.performance_insights_retention_period, var.rds_defaults.performance_insights_retention_period, 7)
  performance_insights_kms_key_id        = try(each.value.performance_insights_kms_key_id, var.rds_defaults.performance_insights_kms_key_id, null)
  create_cloudwatch_log_group            = try(each.value.create_cloudwatch_log_group, var.rds_defaults.create_cloudwatch_log_group, false)
  enabled_cloudwatch_logs_exports        = try(each.value.enabled_cloudwatch_logs_exports, var.rds_defaults.enabled_cloudwatch_logs_exports, [])
  cloudwatch_log_group_retention_in_days = try(each.value.cloudwatch_log_group_retention_in_days, var.rds_defaults.cloudwatch_log_group_retention_in_days, 7)
  cloudwatch_log_group_kms_key_id        = try(each.value.cloudwatch_log_group_kms_key_id, var.rds_defaults.cloudwatch_log_group_kms_key_id, null)

  ## databases with license
  license_model = try(each.value.license_model, var.rds_defaults.license_model, null)

  ## SQL Server
  timezone = try(each.value.timezone, var.rds_defaults.timezone, null)

  ## Oracle
  replicate_source_db = try(each.value.replicate_source_db, var.rds_defaults.replicate_source_db, null)
  replica_mode        = try(each.value.replica_mode, var.rds_defaults.replica_mode, null)
  character_set_name  = try(each.value.character_set_name, var.rds_defaults.character_set_name, null)

  ## MySQL
  s3_import = try(each.value.s3_import, var.rds_defaults.s3_import, null)

  tags = merge(local.common_tags, try(each.value.tags, var.rds_defaults.tags, null))
}