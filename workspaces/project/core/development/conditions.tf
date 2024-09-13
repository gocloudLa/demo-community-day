locals {
  zone_public  = "${local.metadata.key.env}" == "prd" ? "${local.metadata.public_domain}" : "${local.metadata.key.env}.${local.metadata.public_domain}"
  zone_private = "${local.metadata.key.env}" == "prd" ? "${local.metadata.private_domain}" : "${local.metadata.key.env}.${local.metadata.private_domain}"
}
