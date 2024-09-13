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

  # VPC Name
  vpc_name = local.common_name_prefix

  # RDS
  default_security_group_rds = [
    {
      rule        = "mysql-tcp"
      cidr_blocks = data.aws_vpc.this.cidr_block
    }
  ]

}
