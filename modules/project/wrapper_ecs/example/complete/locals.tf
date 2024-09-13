locals {

  metadata = {
    aws_region  = "us-east-1"
    environment = "Production"

    public_domain  = "democorp.cloud"
    private_domain = "democorp"

    key = {
      company = "dmc"
      region  = "use1"
      env     = "prd"
    }
  }

  common_name = join("-", [
    local.metadata.key.company,
    local.metadata.key.env
  ])

  vpc_cidr = data.aws_vpc.this.cidr_block
}
