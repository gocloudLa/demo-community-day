locals {
  metadata = var.metadata

  common_name_prefix = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_prefix,
    var.project
  ])

  common_tags = {
    "company"     = local.metadata.key.company
    "provisioner" = "terraform"
    "environment" = local.metadata.environment
    "project"     = var.project
    "created-by"  = "GoCloud.la"
  }

  default_aws_acm_certificate = "*.${local.common_name_prefix}.internal"

  # VPC Name
  vpc_name = local.common_name_prefix

}
