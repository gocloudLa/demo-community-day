locals {

  metadata = {
    aws_region = "us-east-2"

    environment = "Development"

    public_domain  = "democorp.cloud"
    private_domain = "democorp"

    key = {
      company = "dmc"
      region  = "use2"
      env     = "dev"
    }
  }

  common_name = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

}
