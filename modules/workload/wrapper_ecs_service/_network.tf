# Security Group
locals {
  security_group_rules_calculated_tmp = [
    for service_key, service_config in var.ecs_service_parameters : {
      "${service_key}" = {
        for container_key, container in try(service_config.containers, {}) :
        "${service_key}-${container_key}" => [{
          for port in try(container.ports, []) :
          "${service_key}-${port["container_port"]}" => {
            "type"        = "ingress"
            "from_port"   = try(port["host_port"], port["container_port"])
            "to_port"     = try(port["host_port"], port["container_port"])
            "protocol"    = "tcp"
            "description" = "Service port"
            "cidr_blocks" = [data.aws_vpc.this[service_key].cidr_block]
          }
        }]
      }
    }
  ]
  security_group_rules_calculated_tmp2 = merge(flatten(local.security_group_rules_calculated_tmp)...)

  security_group_rules_calculated = {
    for service_key, service_config in local.security_group_rules_calculated_tmp2 :
    service_key => merge(
      merge([
        for container_key, container in service_config : {
          for rule_key, rule_config in container[0] : rule_key => rule_config
        }
    ]...), local.security_group_rules_default)
  }

  security_group_rules_default = {
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}