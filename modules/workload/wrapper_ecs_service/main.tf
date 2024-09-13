module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.9.1"

  for_each = var.ecs_service_parameters

  name                     = "${local.common_name}-${each.key}"
  alarms                   = try(each.value.alarms, var.ecs_service_defaults.alarms, {})
  assign_public_ip         = try(each.value.assign_public_ip, var.ecs_service_defaults.assign_public_ip, false)
  autoscaling_max_capacity = try(each.value.autoscaling_max_capacity, var.ecs_service_defaults.autoscaling_max_capacity, 10)
  autoscaling_min_capacity = try(each.value.autoscaling_min_capacity, var.ecs_service_defaults.autoscaling_min_capacity, 1)
  autoscaling_policies = try(each.value.autoscaling_policies, var.ecs_service_defaults.autoscaling_policies, {
    cpu = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageCPUUtilization"
        }
      }
    }
    memory = {
      policy_type = "TargetTrackingScaling"

      target_tracking_scaling_policy_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ECSServiceAverageMemoryUtilization"
        }
      }
    }
  })
  autoscaling_scheduled_actions      = try(each.value.autoscaling_scheduled_actions, var.ecs_service_defaults.autoscaling_scheduled_actions, {})
  capacity_provider_strategy         = try(each.value.capacity_provider_strategy, var.ecs_service_defaults.capacity_provider_strategy, {})
  cluster_arn                        = data.aws_ecs_cluster.this[each.key].id # try(each.value.cluster_arn, var.ecs_service_defaults.cluster_arn, "")
  container_definition_defaults      = try(each.value.container_definition_defaults, var.ecs_service_defaults.container_definition_defaults, {})
  container_definitions              = local.container_definitions[each.key] # try(each.value.container_definitions, var.ecs_service_defaults.container_definitions, {})
  cpu                                = try(each.value.cpu, var.ecs_service_defaults.cpu, 1024)
  create                             = try(each.value.create, var.ecs_service_defaults.create, true)
  create_iam_role                    = try(each.value.create_iam_role, var.ecs_service_defaults.create_iam_role, true)
  create_security_group              = try(each.value.create_security_group, var.ecs_service_defaults.create_security_group, true)
  create_task_definition             = try(each.value.create_task_definition, var.ecs_service_defaults.create_task_definition, true)
  create_task_exec_iam_role          = try(each.value.create_task_exec_iam_role, var.ecs_service_defaults.create_task_exec_iam_role, true)
  create_task_exec_policy            = try(each.value.create_task_exec_policy, var.ecs_service_defaults.create_task_exec_policy, true)
  create_tasks_iam_role              = try(each.value.create_tasks_iam_role, var.ecs_service_defaults.create_tasks_iam_role, true)
  deployment_circuit_breaker         = try(each.value.deployment_circuit_breaker, var.ecs_service_defaults.deployment_circuit_breaker, {})
  deployment_controller              = try(each.value.deployment_controller, var.ecs_service_defaults.deployment_controller, {})
  deployment_maximum_percent         = try(each.value.deployment_maximum_percent, var.ecs_service_defaults.deployment_maximum_percent, 200)
  deployment_minimum_healthy_percent = try(each.value.deployment_minimum_healthy_percent, var.ecs_service_defaults.deployment_minimum_healthy_percent, 66)
  desired_count                      = try(each.value.ecs_execution_type, null) == "schedule" ? 0 : try(each.value.desired_count, var.ecs_service_defaults.desired_count, 1)                  # try(each.value.desired_count, var.ecs_service_defaults.desired_count, 1)
  enable_autoscaling                 = try(each.value.ecs_execution_type, null) == "schedule" ? false : try(each.value.enable_autoscaling, var.ecs_service_defaults.enable_autoscaling, true) # try(each.value.enable_autoscaling, var.ecs_service_defaults.enable_autoscaling, true)
  enable_ecs_managed_tags            = try(each.value.enable_ecs_managed_tags, var.ecs_service_defaults.enable_ecs_managed_tags, true)
  enable_execute_command             = try(each.value.enable_execute_command, var.ecs_service_defaults.enable_execute_command, true)
  ephemeral_storage                  = try(each.value.ephemeral_storage, var.ecs_service_defaults.ephemeral_storage, {})
  external_id                        = try(each.value.external_id, var.ecs_service_defaults.external_id, null)
  family                             = try(each.value.family, var.ecs_service_defaults.family, null)
  force_delete                       = try(each.value.force_delete, var.ecs_service_defaults.force_delete, null)
  force_new_deployment               = try(each.value.force_new_deployment, var.ecs_service_defaults.force_new_deployment, true)
  health_check_grace_period_seconds  = try(each.value.health_check_grace_period_seconds, var.ecs_service_defaults.health_check_grace_period_seconds, null)
  iam_role_arn                       = try(each.value.iam_role_arn, var.ecs_service_defaults.iam_role_arn, null)
  iam_role_description               = try(each.value.iam_role_description, var.ecs_service_defaults.iam_role_description, null)
  iam_role_name                      = try(each.value.iam_role_name, var.ecs_service_defaults.iam_role_name, null)
  iam_role_path                      = try(each.value.iam_role_path, var.ecs_service_defaults.iam_role_path, null)
  iam_role_permissions_boundary      = try(each.value.iam_role_permissions_boundary, var.ecs_service_defaults.iam_role_permissions_boundary, null)
  iam_role_statements                = try(each.value.iam_role_statements, var.ecs_service_defaults.iam_role_statements, {})
  iam_role_tags                      = try(each.value.iam_role_tags, var.ecs_service_defaults.iam_role_tags, {})
  iam_role_use_name_prefix           = try(each.value.iam_role_use_name_prefix, var.ecs_service_defaults.iam_role_use_name_prefix, true)
  ignore_task_definition_changes     = try(each.value.ignore_task_definition_changes, var.ecs_service_defaults.ignore_task_definition_changes, false)
  inference_accelerator              = try(each.value.inference_accelerator, var.ecs_service_defaults.inference_accelerator, {})
  ipc_mode                           = try(each.value.ipc_mode, var.ecs_service_defaults.ipc_mode, null)
  launch_type                        = try(each.value.launch_type, var.ecs_service_defaults.launch_type, "FARGATE")
  load_balancer                      = local.load_balancer_calculated[each.key] # try(each.value.load_balancer, var.ecs_service_defaults.load_balancer, {})
  memory                             = try(each.value.memory, var.ecs_service_defaults.memory, 2048)
  network_mode                       = try(each.value.network_mode, var.ecs_service_defaults.network_mode, "awsvpc")
  ordered_placement_strategy         = try(each.value.ordered_placement_strategy, var.ecs_service_defaults.ordered_placement_strategy, {})
  pid_mode                           = try(each.value.pid_mode, var.ecs_service_defaults.pid_mode, null)
  placement_constraints              = try(each.value.placement_constraints, var.ecs_service_defaults.placement_constraints, {})
  platform_version                   = try(each.value.platform_version, var.ecs_service_defaults.platform_version, null)
  propagate_tags                     = try(each.value.propagate_tags, var.ecs_service_defaults.propagate_tags, null)
  proxy_configuration                = try(each.value.proxy_configuration, var.ecs_service_defaults.proxy_configuration, {})
  requires_compatibilities           = try(each.value.requires_compatibilities, var.ecs_service_defaults.requires_compatibilities, ["FARGATE"])
  runtime_platform = try(each.value.runtime_platform, var.ecs_service_defaults.runtime_platform, {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  })
  scale                                   = try(each.value.scale, var.ecs_service_defaults.scale, {})
  scheduling_strategy                     = try(each.value.scheduling_strategy, var.ecs_service_defaults.scheduling_strategy, null)
  security_group_description              = try(each.value.security_group_description, var.ecs_service_defaults.security_group_description, null)
  security_group_ids                      = try(each.value.security_group_ids, var.ecs_service_defaults.security_group_ids, [])
  security_group_name                     = try(each.value.security_group_name, var.ecs_service_defaults.security_group_name, null)
  security_group_rules                    = local.security_group_rules_calculated[each.key] # try(each.value.security_group_rules, var.ecs_service_defaults.security_group_rules, {})
  security_group_tags                     = try(each.value.security_group_tags, var.ecs_service_defaults.security_group_tags, {})
  security_group_use_name_prefix          = try(each.value.security_group_use_name_prefix, var.ecs_service_defaults.security_group_use_name_prefix, true)
  service_connect_configuration           = try(each.value.service_connect_configuration, var.ecs_service_defaults.service_connect_configuration, {})
  service_registries                      = try(each.value.service_registries, var.ecs_service_defaults.service_registries, {})
  service_tags                            = try(each.value.service_tags, var.ecs_service_defaults.service_tags, {})
  skip_destroy                            = try(each.value.skip_destroy, var.ecs_service_defaults.skip_destroy, null)
  subnet_ids                              = data.aws_subnets.this[each.key].ids
  task_definition_arn                     = try(each.value.task_definition_arn, var.ecs_service_defaults.task_definition_arn, null)
  task_definition_placement_constraints   = try(each.value.task_definition_placement_constraints, var.ecs_service_defaults.task_definition_placement_constraints, {})
  task_exec_iam_role_arn                  = try(each.value.task_exec_iam_role_arn, var.ecs_service_defaults.task_exec_iam_role_arn, null)
  task_exec_iam_role_description          = try(each.value.task_exec_iam_role_description, var.ecs_service_defaults.task_exec_iam_role_description, null)
  task_exec_iam_role_name                 = try(each.value.task_exec_iam_role_name, var.ecs_service_defaults.task_exec_iam_role_name, null)
  task_exec_iam_role_path                 = try(each.value.task_exec_iam_role_path, var.ecs_service_defaults.task_exec_iam_role_path, null)
  task_exec_iam_role_permissions_boundary = try(each.value.task_exec_iam_role_permissions_boundary, var.ecs_service_defaults.task_exec_iam_role_permissions_boundary, null)
  task_exec_iam_role_policies             = try(each.value.task_exec_iam_role_policies, var.ecs_service_defaults.task_exec_iam_role_policies, {})
  task_exec_iam_role_tags                 = try(each.value.task_exec_iam_role_tags, var.ecs_service_defaults.task_exec_iam_role_tags, {})
  task_exec_iam_role_use_name_prefix      = try(each.value.task_exec_iam_role_use_name_prefix, var.ecs_service_defaults.task_exec_iam_role_use_name_prefix, true)
  task_exec_iam_statements                = try(each.value.task_exec_iam_statements, var.ecs_service_defaults.task_exec_iam_statements, {})
  task_exec_secret_arns                   = try(each.value.task_exec_secret_arns, var.ecs_service_defaults.task_exec_secret_arns, ["arn:aws:secretsmanager:*:*:secret:${local.common_name}-${each.key}-*"])
  task_exec_ssm_param_arns                = try(each.value.task_exec_ssm_param_arns, var.ecs_service_defaults.task_exec_ssm_param_arns, ["arn:aws:ssm:*:*:parameter/${local.common_name}-${each.key}-*"])
  task_tags                               = try(each.value.task_tags, var.ecs_service_defaults.task_tags, {})
  tasks_iam_role_arn                      = try(each.value.tasks_iam_role_arn, var.ecs_service_defaults.tasks_iam_role_arn, null)
  tasks_iam_role_description              = try(each.value.tasks_iam_role_description, var.ecs_service_defaults.tasks_iam_role_description, null)
  tasks_iam_role_name                     = try(each.value.tasks_iam_role_name, var.ecs_service_defaults.tasks_iam_role_name, null)
  tasks_iam_role_path                     = try(each.value.tasks_iam_role_path, var.ecs_service_defaults.tasks_iam_role_path, null)
  tasks_iam_role_permissions_boundary     = try(each.value.tasks_iam_role_permissions_boundary, var.ecs_service_defaults.tasks_iam_role_permissions_boundary, null)
  tasks_iam_role_policies                 = try(each.value.tasks_iam_role_policies, var.ecs_service_defaults.tasks_iam_role_policies, {})
  tasks_iam_role_statements               = try(each.value.tasks_iam_role_statements, var.ecs_service_defaults.tasks_iam_role_statements, {})
  tasks_iam_role_tags                     = try(each.value.tasks_iam_role_tags, var.ecs_service_defaults.tasks_iam_role_tags, {})
  tasks_iam_role_use_name_prefix          = try(each.value.tasks_iam_role_use_name_prefix, var.ecs_service_defaults.tasks_iam_role_use_name_prefix, true)
  timeouts                                = try(each.value.timeouts, var.ecs_service_defaults.timeouts, {})
  triggers                                = try(each.value.triggers, var.ecs_service_defaults.triggers, {})
  volume                                  = try(each.value.volume, var.ecs_service_defaults.volume, {})
  wait_for_steady_state                   = try(each.value.wait_for_steady_state, var.ecs_service_defaults.wait_for_steady_state, null)
  wait_until_stable                       = try(each.value.wait_until_stable, var.ecs_service_defaults.wait_until_stable, null)
  wait_until_stable_timeout               = try(each.value.wait_until_stable_timeout, var.ecs_service_defaults.wait_until_stable_timeout, null)

  tags = merge(local.common_tags, { workload = "${each.key}" })
}