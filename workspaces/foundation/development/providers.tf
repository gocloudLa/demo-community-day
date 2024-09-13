provider "aws" {
  region = local.metadata.aws_region
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}