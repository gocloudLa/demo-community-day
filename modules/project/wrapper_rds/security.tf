module "security_group_rds" {
  for_each = var.rds_parameters

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name                     = "${local.common_name}-rds-${each.key}"
  vpc_id                   = data.aws_vpc.this.id
  use_name_prefix          = false
  ingress_with_cidr_blocks = lookup(each.value, "ingress_with_cidr_blocks", local.default_security_group_rds)

  tags = local.common_tags
}