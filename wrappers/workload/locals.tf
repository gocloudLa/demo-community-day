locals {

  metadata = var.metadata

  common_name_base = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_base,
    local.metadata.key.project
  ])

  common_tags = {
    "company"     = local.metadata.key.company
    "provisioner" = "terraform"
    "environment" = local.metadata.environment
    "project"     = local.metadata.project
    "created-by"  = "GoCloud.la"
  }
}
