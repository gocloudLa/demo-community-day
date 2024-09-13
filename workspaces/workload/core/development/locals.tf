locals {

  metadata = {
    aws_region = "us-east-2"

    environment = "Development"
    project     = "core"

    public_domain  = "democorp.cloud"
    private_domain = "democorp"

    key = {
      company = "dmc"
      region  = "use2"
      env     = "dev"
      project = "core"
    }
  }

  common_name_base = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  common_name = join("-", [
    local.common_name_base,
    local.metadata.key.project
  ])

}
