module "wrapper_acm" {
  source = "../../"

  metadata = local.metadata

  acm_parameters = {
    "${local.zone_public}" = {
      route53_zone_name = "${local.zone_public}"
      subject_alternative_names = [
        "*.${local.zone_public}"
      ]
    }
  }
}