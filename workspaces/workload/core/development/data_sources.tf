/*----------------------------------------------------------------------*/
/* AWS Caller Identity (account_id, user_id, arn)                       */
/*----------------------------------------------------------------------*/
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_acm_certificate" "this" {
  provider = aws.use1

  domain      = local.zone_public
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_lb" "external_alb" {
  name = "${local.common_name_base}-core-external-00"
}

data "aws_s3_bucket" "storage" {
  bucket = "${local.common_name}-storage"
}

data "aws_secretsmanager_secret" "database_connection" {
  name = "rds-${local.common_name}-mysql-00"
}

data "aws_secretsmanager_secret_version" "database_connection" {
  secret_id = data.aws_secretsmanager_secret.database_connection.id
}

locals {
  db_user = "${jsondecode(data.aws_secretsmanager_secret_version.database_connection.secret_string)["username"]}"
  db_password = "${jsondecode(data.aws_secretsmanager_secret_version.database_connection.secret_string)["password"]}"
  db_host = "${jsondecode(data.aws_secretsmanager_secret_version.database_connection.secret_string)["host"]}"
  db_port = "${jsondecode(data.aws_secretsmanager_secret_version.database_connection.secret_string)["port"]}"
}