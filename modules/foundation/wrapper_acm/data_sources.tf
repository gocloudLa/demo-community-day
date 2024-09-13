data "aws_caller_identity" "current" {}

/*----------------------------------------------------------------------*/
/* Route53 | datasources                                                */
/*----------------------------------------------------------------------*/

data "aws_route53_zone" "acm" {
  for_each     = var.acm_parameters
  name         = each.key
  private_zone = false
}