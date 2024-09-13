data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  for_each = var.ecs_service_parameters

  filter {
    name = "tag:Name"
    values = [
      try(each.value.vpc_name, local.default_vpc_name)
    ]
  }
}

data "aws_ecs_cluster" "this" {
  for_each = var.ecs_service_parameters

  cluster_name = try(each.value.ecs_cluster_name, local.default_ecs_cluster_name)
}

data "aws_subnets" "this" {
  for_each = var.ecs_service_parameters

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this[each.key].id]
  }

  tags = {
    Name = try(each.value.subnet_name, local.default_subnet_name)
  }
}
