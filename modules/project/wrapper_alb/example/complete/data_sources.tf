data "aws_acm_certificate" "this" {
  domain      = local.zone_public
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.common_name_prefix}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = "${local.common_name_prefix}-public*"
  }
}