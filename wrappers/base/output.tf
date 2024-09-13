output "route53_zones" {
  description = "Name servers of Route53 zone"
  value       = module.wrapper_route53.route53_zones
}
