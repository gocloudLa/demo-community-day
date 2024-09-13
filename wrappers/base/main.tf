module "wrapper_vpc" {
  source = "../../modules/base/wrapper_vpc"

  metadata = var.metadata

  vpc_parameters = var.vpc_parameters
  vpc_defaults   = var.vpc_defaults
}

module "wrapper_route53" {
  source = "../../modules/base/wrapper_route53"

  metadata = var.metadata

  route53_parameters = var.route53_parameters
  route53_defaults   = var.route53_defaults

  vpc_id = module.wrapper_vpc.vpc.vpc_id
}