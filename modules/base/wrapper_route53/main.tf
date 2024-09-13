resource "aws_route53_zone" "this" {
  for_each = lookup(var.route53_parameters, "zones", {})

  name = each.key
  dynamic "vpc" {
    for_each = lookup(each.value, "private", false) == true ? { validate = true } : {}

    content {
      vpc_id = var.vpc_id
    }
  }

  tags = local.common_tags
}