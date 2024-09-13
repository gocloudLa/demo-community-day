# ENVIRONMENT
locals {
  app_container_definition_environment_tmp = [
    for service_key, service in var.ecs_service_parameters : {
      for container_key, container in service.containers :
      "${service_key}-${container_key}" => [
        for key, value in try(container.map_environment, []) :
        {
          "name"  = key
          "value" = value
        }
      ]
    }
  ]
  app_container_definition_environment = merge(flatten(local.app_container_definition_environment_tmp)...)
}

locals {
  app_container_definition_port_mappings_tmp = [
    for service_key, service in var.ecs_service_parameters : {
      for container_key, container in service.containers :
      "${service_key}-${container_key}" => [
        for port in try(container.ports, []) :
        {
          "containerPort" = try(port["container_port"], null)
          "hostPort"      = try(port["host_port"], port["container_port"])
          "protocol"      = try(port["protocol"], "tcp")
        }
      ]
    }
  ]

  app_container_definition_port_mappings = merge(flatten(local.app_container_definition_port_mappings_tmp)...)

  container_definitions_tmp = [
    for service_key, service_config in var.ecs_service_parameters : {
      "${service_key}" = {
        for container_key, container in try(service_config.containers, {}) :
        "${container_key}" => merge(
          container,
          { port_mappings = local.app_container_definition_port_mappings["${service_key}-${container_key}"] },
          { environment = local.app_container_definition_environment["${service_key}-${container_key}"] },
          { image = try(module.ecr["${service_key}-${container_key}"].repository_url, container.image) },
          { readonly_root_filesystem = try(module.ecr["${service_key}-${container_key}"].readonly_root_filesystem, false) },
          { user = try(container.user, null) } # FIX, sin esto el modulo le pone user = 0 y rompen los contenedores bitnami/redis:7.0.10 y bitnami/openldap:2.6.4-debian-11-r4
        )
      }
    }
  ]
  container_definitions = merge(flatten(local.container_definitions_tmp)...)
}