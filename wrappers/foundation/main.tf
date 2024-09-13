module "wrapper_acm" {
  source = "../../modules/foundation/wrapper_acm"

  metadata = var.metadata

  acm_parameters = var.acm_parameters
  acm_defaults   = var.acm_defaults

  providers = {
    aws.use1 = aws.use1
  }
}