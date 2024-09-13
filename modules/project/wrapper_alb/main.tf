module "alb" {
  for_each = var.alb_parameters
  source   = "terraform-aws-modules/alb/aws"
  version  = "8.2.1"

  create_lb                        = true
  name                             = "${local.common_name}-${each.key}"
  security_groups                  = [module.security_group_alb[each.key].security_group_id]
  drop_invalid_header_fields       = try(each.value.drop_invalid_header_fields, var.alb_defaults.drop_invalid_header_fields, false)
  enable_deletion_protection       = try(each.value.enable_deletion_protection, var.alb_defaults.enable_deletion_protection, false)
  enable_http2                     = try(each.value.enable_http2, var.alb_defaults.enable_http2, true)
  enable_cross_zone_load_balancing = try(each.value.enable_cross_zone_load_balancing, var.alb_defaults.enable_cross_zone_load_balancing, false)
  extra_ssl_certs                  = try(each.value.extra_ssl_certs, var.alb_defaults.extra_ssl_certs, [])
  https_listeners                  = try(each.value.https_listeners, var.alb_defaults.https_listeners, [])
  http_tcp_listeners               = try(each.value.http_tcp_listeners, var.alb_defaults.http_tcp_listeners, [])
  https_listener_rules             = try(each.value.https_listener_rules, var.alb_defaults.https_listener_rules, [])
  http_tcp_listener_rules          = try(each.value.http_tcp_listener_rules, var.alb_defaults.http_tcp_listener_rules, [])
  idle_timeout                     = try(each.value.idle_timeout, var.alb_defaults.idle_timeout, 60)
  ip_address_type                  = try(each.value.ip_address_type, var.alb_defaults.ip_address_type, "ipv4")
  listener_ssl_policy_default      = try(each.value.listener_ssl_policy_default, var.alb_defaults.listener_ssl_policy_default, "ELBSecurityPolicy-2016-08")
  internal                         = try(each.value.internal, var.alb_defaults.internal, false)
  load_balancer_create_timeout     = try(each.value.load_balancer_create_timeout, var.alb_defaults.load_balancer_create_timeout, "10m")
  load_balancer_delete_timeout     = try(each.value.load_balancer_delete_timeout, var.alb_defaults.load_balancer_delete_timeout, "10m")
  name_prefix                      = try(each.value.name_prefix, var.alb_defaults.name_prefix, null)
  load_balancer_type               = try(each.value.load_balancer_type, var.alb_defaults.load_balancer_type, "application")
  load_balancer_update_timeout     = try(each.value.load_balancer_update_timeout, var.alb_defaults.load_balancer_update_timeout, "10m")
  access_logs                      = try(each.value.access_logs, var.alb_defaults.access_logs, {})
  subnets                          = try(each.value.subnets, var.alb_defaults.subnets, null)
  subnet_mapping                   = try(each.value.subnet_mapping, var.alb_defaults.subnet_mapping, [])
  lb_tags                          = try(each.value.lb_tags, var.alb_defaults.lb_tags, {})
  target_group_tags                = try(each.value.target_group_tags, var.alb_defaults.target_group_tags, {})
  https_listener_rules_tags        = try(each.value.https_listener_rules_tags, var.alb_defaults.https_listener_rules_tags, {})
  http_tcp_listener_rules_tags     = try(each.value.http_tcp_listener_rules_tags, var.alb_defaults.http_tcp_listener_rules_tags, {})
  https_listeners_tags             = try(each.value.https_listeners_tags, var.alb_defaults.https_listeners_tags, {})
  http_tcp_listeners_tags          = try(each.value.http_tcp_listeners_tags, var.alb_defaults.http_tcp_listeners_tags, {})
  target_groups                    = try(each.value.target_groups, var.alb_defaults.target_groups, [])
  vpc_id                           = try(each.value.vpc_id, var.alb_defaults.vpc_id, null)
  enable_waf_fail_open             = try(each.value.enable_waf_fail_open, var.alb_defaults.enable_waf_fail_open, false)
  desync_mitigation_mode           = try(each.value.desync_mitigation_mode, var.alb_defaults.desync_mitigation_mode, "defensive")
  putin_khuylo                     = try(each.value.putin_khuylo, var.alb_defaults.putin_khuylo, true)

  tags = local.common_tags

}