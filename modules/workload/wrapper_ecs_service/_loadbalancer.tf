locals {
  # ARMO OBJETO PARA CREAR TARGET GROUPS
  create_target_groups_tmp = [
    for service_name, service_config in var.ecs_service_parameters :
    [
      for container_name, container_config in service_config.containers :
      [
        for port_key, port_values in try(container_config.ports, {}) :
        {
          "${service_name}-${container_name}-${port_key}" = {
            "service_name"   = service_name
            "container_name" = container_name
            "name"           = "${local.common_name}-${service_name}-${port_values.container_port}"
            "port_key"       = port_key
            "port_values"    = port_values
          }
        }
        if can(port_values.load_balancer)
      ]
    ]
  ]
  create_target_groups = merge(flatten(local.create_target_groups_tmp)...)

  create_listener_rules_tmp = [
    for service_name, service_config in var.ecs_service_parameters :
    [
      for container_name, container_config in service_config.containers :
      [
        for port_key, port_values in try(container_config.ports, {}) :
        [
          for rule_key, rule_values in try(port_values.load_balancer.listener_rules, {}) :
          {
            "${service_name}-${container_name}-${port_key}-${rule_key}" = {
              "target_group_key" = "${service_name}-${container_name}-${port_key}"
              "name"             = "${local.common_name}-${service_name}-${port_values.container_port}"
              "port_key"         = port_key
              "rule_values" = merge(rule_values, {
                actions = can(rule_values) && can(rule_values.actions) ? rule_values.actions : [
                  {
                    type = "forward"
                  }
                ]
              })
            }
          }
        ]
        if can(port_values.load_balancer)
      ]
    ]
  ]
  create_listener_rules = merge(flatten(local.create_listener_rules_tmp)...)
}
# output "create_listener_rules" {
#   value = local.create_listener_rules
# }


locals {
  # Similar al del security group
  load_balancer_calculated_tmp = [
    for service_key, service_config in var.ecs_service_parameters : {
      "${service_key}" = {
        for container_key, container in try(service_config.containers, {}) :
        "${service_key}-${container_key}" => [{
          for port_key, port in try(container.ports, []) :
          "${service_key}-${port["container_port"]}" => {
            "target_group_arn" = aws_lb_target_group.this["${service_key}-${container_key}-${port_key}"].arn
            "debug"            = "${service_key}-${container_key}-${port_key}"
            "container_name"   = "${container_key}"
            "container_port"   = try(port["host_port"], port["container_port"])
          }
          if can(port.load_balancer)
        }]
      }
    }
  ]
  load_balancer_calculated_tmp2 = merge(flatten(local.load_balancer_calculated_tmp)...)

  load_balancer_calculated = {
    for service_key, service_config in local.load_balancer_calculated_tmp2 :
    service_key => merge([
      for container_key, container in service_config : {
        for rule_key, rule_config in container[0] : rule_key => rule_config
      }
    ]...)
  }
}

# output "load_balancer_calculated" {
#   value = local.load_balancer_calculated
# }
/*----------------------------------------------------------------------*/
/* ALB | Target Group & Listener Rule                                   */
/*----------------------------------------------------------------------*/

# [SERVICE][CONTAINER][PORT]
resource "aws_lb_target_group" "this" {
  for_each = local.create_target_groups

  name                 = each.value.name
  vpc_id               = data.aws_vpc.this[each.value.service_name].id
  port                 = each.value.port_values.container_port
  protocol             = try(each.value.port_values.load_balancer.protocol, "HTTP")
  target_type          = "ip"
  deregistration_delay = try(each.value.port_values.load_balancer.deregistration_delay, 300)
  slow_start           = try(each.value.port_values.load_balancer.slow_start, 0)

  health_check {
    path                = try(each.value.port_values.load_balancer.health_check.path, "/")
    protocol            = try(each.value.port_values.load_balancer.health_check.protocol, each.value.port_values.load_balancer.protocol, "HTTP")
    matcher             = try(each.value.port_values.load_balancer.health_check.matcher, 200)
    interval            = try(each.value.port_values.load_balancer.health_check.interval, 30)
    timeout             = try(each.value.port_values.load_balancer.health_check.timeout, 5)
    healthy_threshold   = try(each.value.port_values.load_balancer.health_check.healthy_threshold, 3)
    unhealthy_threshold = try(each.value.port_values.load_balancer.health_check.unhealthy_threshold, 3)
  }

  tags = local.common_tags

}

data "aws_lb" "this" {
  for_each = local.create_target_groups
  name     = try(each.value.port_values.load_balancer.alb_name, "${local.common_name}-internal-00")
}

data "aws_lb_listener" "this" {
  for_each = local.create_target_groups

  load_balancer_arn = data.aws_lb.this[each.key].arn
  port              = try(each.value.port_values.load_balancer.alb_listener_port, 443)
}

resource "aws_lb_listener_rule" "this" {
  for_each = local.create_listener_rules

  listener_arn = data.aws_lb_listener.this[each.value.target_group_key].arn
  priority     = try(each.value.rule_values.priority, null)

  # authenticate-cognito actions
  dynamic "action" {
    for_each = [
      for action_rule in each.value.rule_values.actions :
      action_rule
      if action_rule.type == "authenticate-cognito"
    ]

    content {
      type = action.value["type"]
      authenticate_cognito {
        authentication_request_extra_params = lookup(action.value, "authentication_request_extra_params", null)
        on_unauthenticated_request          = lookup(action.value, "on_authenticated_request", null)
        scope                               = lookup(action.value, "scope", null)
        session_cookie_name                 = lookup(action.value, "session_cookie_name", null)
        session_timeout                     = lookup(action.value, "session_timeout", null)
        user_pool_arn                       = action.value["user_pool_arn"]
        user_pool_client_id                 = action.value["user_pool_client_id"]
        user_pool_domain                    = action.value["user_pool_domain"]
      }
    }
  }

  # authenticate-oidc actions
  dynamic "action" {
    for_each = [
      for action_rule in each.value.rule_values.actions :
      action_rule
      if action_rule.type == "authenticate-oidc"
    ]

    content {
      type = action.value["type"]
      authenticate_oidc {
        # Max 10 extra params
        authentication_request_extra_params = lookup(action.value, "authentication_request_extra_params", null)
        authorization_endpoint              = action.value["authorization_endpoint"]
        client_id                           = action.value["client_id"]
        client_secret                       = action.value["client_secret"]
        issuer                              = action.value["issuer"]
        on_unauthenticated_request          = lookup(action.value, "on_unauthenticated_request", null)
        scope                               = lookup(action.value, "scope", null)
        session_cookie_name                 = lookup(action.value, "session_cookie_name", null)
        session_timeout                     = lookup(action.value, "session_timeout", null)
        token_endpoint                      = action.value["token_endpoint"]
        user_info_endpoint                  = action.value["user_info_endpoint"]
      }
    }
  }

  # redirect actions
  dynamic "action" {
    for_each = [
      for action_rule in each.value.rule_values.actions :
      action_rule
      if action_rule.type == "redirect"
    ]

    content {
      type = action.value["type"]
      redirect {
        host        = lookup(action.value, "host", null)
        path        = lookup(action.value, "path", null)
        port        = lookup(action.value, "port", null)
        protocol    = lookup(action.value, "protocol", null)
        query       = lookup(action.value, "query", null)
        status_code = action.value["status_code"]
      }
    }
  }

  # fixed-response actions
  dynamic "action" {
    for_each = [
      for action_rule in each.value.rule_values.actions :
      action_rule
      if action_rule.type == "fixed-response"
    ]

    content {
      type = action.value["type"]
      fixed_response {
        message_body = lookup(action.value, "message_body", null)
        status_code  = lookup(action.value, "status_code", null)
        content_type = action.value["content_type"]
      }
    }
  }

  # forward actions
  dynamic "action" {
    for_each = [
      for action_rule in each.value.rule_values.actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = aws_lb_target_group.this[each.value.target_group_key].id
    }
  }

  # # weighted forward actions
  # dynamic "action" {
  #   for_each = [
  #     for action_rule in each.value.rule_values.actions :
  #     action_rule
  #     if action_rule.type == "weighted-forward"
  #   ]

  #   content {
  #     type = "forward"
  #     forward {
  #       dynamic "target_group" {
  #         for_each = action.value["target_groups"]

  #         content {
  #           arn    = aws_lb_target_group.main[target_group.value["target_group_index"]].id
  #           weight = target_group.value["weight"]
  #         }
  #       }
  #       dynamic "stickiness" {
  #         for_each = [lookup(action.value, "stickiness", {})]

  #         content {
  #           enabled  = try(stickiness.value["enabled"], false)
  #           duration = try(stickiness.value["duration"], 1)
  #         }
  #       }
  #     }
  #   }
  # }

  # Path Pattern condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "path_patterns", [])) > 0
    ]

    content {
      path_pattern {
        values = condition.value["path_patterns"]
      }
    }
  }

  # Host header condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "host_headers", [])) > 0
    ]

    content {
      host_header {
        values = condition.value["host_headers"]
      }
    }
  }

  # Http header condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "http_headers", [])) > 0
    ]

    content {
      dynamic "http_header" {
        for_each = condition.value["http_headers"]

        content {
          http_header_name = http_header.value["http_header_name"]
          values           = http_header.value["values"]
        }
      }
    }
  }

  # Http request method condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "http_request_methods", [])) > 0
    ]

    content {
      http_request_method {
        values = condition.value["http_request_methods"]
      }
    }
  }

  # Query string condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "query_strings", [])) > 0
    ]

    content {
      dynamic "query_string" {
        for_each = condition.value["query_strings"]

        content {
          key   = lookup(query_string.value, "key", null)
          value = query_string.value["value"]
        }
      }
    }
  }

  # Source IP address condition
  dynamic "condition" {
    for_each = [
      for condition_rule in each.value.rule_values.conditions :
      condition_rule
      if length(lookup(condition_rule, "source_ips", [])) > 0
    ]

    content {
      source_ip {
        values = condition.value["source_ips"]
      }
    }
  }

  tags = local.common_tags
}

/*----------------------------------------------------------------------*/
/* ALB | Dns Records                                                    */
/*----------------------------------------------------------------------*/
locals {
  create_dns_records_tmp = [
    for service_name, service_config in var.ecs_service_parameters :
    [
      for container_name, container_config in service_config.containers :
      [
        for port_key, port_values in try(container_config.ports, {}) :
        [
          for dns_key, dns_values in try(port_values.load_balancer.dns_records, {}) :
          {
            "${service_name}-${container_name}-${port_key}-${dns_key}" = {
              # "name"         = resource_name
              "target_group_key" = "${service_name}-${container_name}-${port_key}"
              "record_name"      = length(dns_key) > 0 ? dns_key : "${service_name}-${container_name}-${port_key}"
              "zone_name"        = dns_values.zone_name
              "private_zone"     = dns_values.private_zone
              "ttl"              = lookup(dns_values, "ttl", 300)
            }
          }
        ]
        if can(port_values.load_balancer)
      ]
    ]
  ]
  create_dns_records = merge(flatten(local.create_dns_records_tmp)...)

}

data "aws_route53_zone" "this" {
  for_each = local.create_dns_records

  zone_id      = lookup(each.value, "zone_id", null)
  name         = lookup(each.value, "zone_name", null)
  private_zone = lookup(each.value, "private_zone", false)
}

resource "aws_route53_record" "this" {
  for_each = local.create_dns_records

  zone_id         = data.aws_route53_zone.this[each.key].zone_id
  name            = lookup(each.value, "record_name")
  allow_overwrite = false
  type            = "A"
  alias {
    name                   = data.aws_lb.this[each.value.target_group_key].dns_name
    zone_id                = data.aws_lb.this[each.value.target_group_key].zone_id
    evaluate_target_health = false
  }
}