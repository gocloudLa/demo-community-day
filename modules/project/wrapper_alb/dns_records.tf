/*----------------------------------------------------------------------*/
/* ALB Variables                                                        */
/*----------------------------------------------------------------------*/
data "aws_route53_zone" "alb" {
  for_each = local.alb_route53

  zone_id      = lookup(each.value, "zone_id", null)
  name         = lookup(each.value, "zone_name", null)
  private_zone = lookup(each.value, "private_zone", false)
}

resource "aws_route53_record" "alb" {
  for_each = local.alb_route53

  zone_id         = data.aws_route53_zone.alb[each.key].zone_id
  name            = lookup(each.value, "record_name")
  allow_overwrite = false
  type            = "A"
  alias {
    name                   = module.alb[each.value.name].lb_dns_name
    zone_id                = module.alb[each.value.name].lb_zone_id
    evaluate_target_health = false
  }
}

locals {
  alb_route53_tmp = [for resource_name, value1 in var.alb_parameters :
    {
      for dns_record_name, value2 in value1.dns_records :
      "${resource_name}-${dns_record_name}" =>
      {
        "name"         = resource_name
        "record_name"  = length(dns_record_name) > 0 ? dns_record_name : "${local.common_name}-${resource_name}"
        "zone_name"    = value2.zone_name
        "private_zone" = value2.private_zone
        "ttl"          = lookup(value2, "ttl", 300)
      }
    }
    if lookup(value1, "dns_records", null) != null
  ]
  alb_route53 = merge(local.alb_route53_tmp...)
}
