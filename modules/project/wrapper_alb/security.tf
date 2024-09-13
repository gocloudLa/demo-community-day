module "security_group_alb" {
  for_each = var.alb_parameters

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name                     = "${local.common_name}-lb-${each.key}"
  vpc_id                   = data.aws_vpc.this.id
  use_name_prefix          = false
  ingress_with_cidr_blocks = lookup(each.value, "ingress_with_cidr_blocks", false)
  egress_with_cidr_blocks  = lookup(each.value, "egress_with_cidr_blocks", local.default_egress_with_cidr_blocks_alb)

  tags = local.common_tags
}
