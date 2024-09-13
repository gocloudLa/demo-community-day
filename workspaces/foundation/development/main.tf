module "foundation" {

  source = "../../../wrappers/foundation"

  providers = {
    aws.use1 = aws.use1
  }

  /*----------------------------------------------------------------------*/
  /* General Variables                                                    */
  /*----------------------------------------------------------------------*/

  metadata = local.metadata

  /*----------------------------------------------------------------------*/
  /* ACM Variables                                                        */
  /*----------------------------------------------------------------------*/
  acm_parameters = {
    "${local.zone_public}" = {
      route53_zone_name = "${local.zone_public}"
      subject_alternative_names = [
        "*.${local.zone_public}"
      ]
    }
  }

}