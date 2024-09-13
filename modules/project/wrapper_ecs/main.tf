module "ecs" {
  for_each = var.ecs_parameters
  source   = "terraform-aws-modules/ecs/aws"
  version  = "4.1.2"

  create                                = true
  cluster_name                          = "${local.common_name}-${each.key}"
  cluster_settings                      = try(each.value.cluster_settings, var.ecs_defaults.cluster_settings, { "name" : "containerInsights", "value" : "enabled" })
  cluster_configuration                 = try(each.value.cluster_configuration, var.ecs_defaults.cluster_configuration, { execute_command_configuration = { logging = "DEFAULT" } })
  default_capacity_provider_use_fargate = try(each.value.default_capacity_provider_use_fargate, var.ecs_defaults.default_capacity_provider_use_fargate, true)
  fargate_capacity_providers            = try(each.value.fargate_capacity_providers, var.ecs_defaults.fargate_capacity_providers, { FARGATE = { default_capacity_provider_strategy = { weight = 0 } } })
  autoscaling_capacity_providers        = try(each.value.autoscaling_capacity_providers, var.ecs_defaults.autoscaling_capacity_providers, {})

  tags = local.common_tags
}