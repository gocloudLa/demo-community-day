/*----------------------------------------------------------------------*/
/* RDS Variables                                                        */
/*----------------------------------------------------------------------*/
resource "aws_secretsmanager_secret" "this" {
  for_each = var.rds_parameters

  name                    = try(each.value.secret.name, var.rds_defaults.secret.name, "rds-${local.common_name}-${each.key}")
  description             = try(each.value.secret.description, var.rds_defaults.secret.description, "Root Secret for rds instance")
  kms_key_id              = try(each.value.secret.kms_key_id, var.rds_defaults.secret.kms_key_id, null)
  recovery_window_in_days = try(each.value.secret.recovery_window_in_days, var.rds_defaults.secret.recovery_window_in_days, 30)
  tags                    = local.common_tags
}

resource "aws_secretsmanager_secret_version" "secret_val" {
  for_each = var.rds_parameters

  secret_id = aws_secretsmanager_secret.this[each.key].id
  secret_string = jsonencode({
    "engine" : "${module.rds[each.key].db_instance_engine}",
    "host" : "${local.common_name}-${each.key}.rds.${each.value.dns_records[""].zone_name}",
    "username" : "${module.rds[each.key].db_instance_username}",
    "password" : "${random_password.this[each.key].result}",
    "dbname" : "",
    "port" : "${module.rds[each.key].db_instance_port}"
    "rds_host" : "${module.rds[each.key].db_instance_address}",
    }
  )
}