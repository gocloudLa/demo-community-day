data "aws_acm_certificate" "this" {
  domain      = local.zone_public
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.common_name}"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = "${local.common_name}-private*"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Name = "${local.common_name}-public*"
  }
}
