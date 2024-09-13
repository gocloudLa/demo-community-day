module "bucket" {

  source   = "terraform-aws-modules/s3-bucket/aws"
  version  = "3.7.0"
  for_each = var.bucket_parameters

  create_bucket                         = try(each.value.create_bucket, var.bucket_defaults.create_bucket, false)
  attach_elb_log_delivery_policy        = try(each.value.attach_elb_log_delivery_policy, var.bucket_defaults.attach_elb_log_delivery_policy, false)
  attach_lb_log_delivery_policy         = try(each.value.attach_lb_log_delivery_policy, var.bucket_defaults.attach_lb_log_delivery_policy, false)
  attach_deny_insecure_transport_policy = try(each.value.attach_deny_insecure_transport_policy, var.bucket_defaults.attach_deny_insecure_transport_policy, false)
  attach_require_latest_tls_policy      = try(each.value.attach_require_latest_tls_policy, var.bucket_defaults.attach_require_latest_tls_policy, false)
  attach_policy                         = try(each.value.attach_policy, var.bucket_defaults.attach_policy, false)
  attach_public_policy                  = try(each.value.attach_public_policy, var.bucket_defaults.attach_public_policy, true)
  attach_inventory_destination_policy   = try(each.value.attach_inventory_destination_policy, var.bucket_defaults.attach_inventory_destination_policy, false)
  attach_analytics_destination_policy   = try(each.value.attach_analytics_destination_policy, var.bucket_defaults.attach_analytics_destination_policy, false)
  bucket                                = "${local.common_name}-${each.key}"
  bucket_prefix                         = try(each.value.bucket_prefix, var.bucket_defaults.bucket_prefix, null)
  acl                                   = try(each.value.acl, var.bucket_defaults.acl, null)
  policy                                = try(each.value.policy, var.bucket_defaults.policy, null)
  tags                                  = local.common_tags
  force_destroy                         = try(each.value.force_destroy, var.bucket_defaults.force_destroy, false)
  acceleration_status                   = try(each.value.acceleration_status, var.bucket_defaults.acceleration_status, null)
  request_payer                         = try(each.value.request_payer, var.bucket_defaults.request_payer, null)
  website                               = try(each.value.website, var.bucket_defaults.website, {})
  cors_rule                             = try(each.value.cors_rule, var.bucket_defaults.cors_rule, [])
  versioning                            = try(each.value.versioning, var.bucket_defaults.versioning, {})
  logging                               = try(each.value.logging, var.bucket_defaults.logging, {})
  grant                                 = try(each.value.grant, var.bucket_defaults.grant, [])
  owner                                 = try(each.value.owner, var.bucket_defaults.owner, {})
  expected_bucket_owner                 = try(each.value.expected_bucket_owner, var.bucket_defaults.expected_bucket_owner, null)
  lifecycle_rule                        = try(each.value.lifecycle_rule, var.bucket_defaults.lifecycle_rule, [])
  replication_configuration             = try(each.value.replication_configuration, var.bucket_defaults.replication_configuration, {})
  server_side_encryption_configuration  = try(each.value.server_side_encryption_configuration, var.bucket_defaults.server_side_encryption_configuration, {})
  intelligent_tiering                   = try(each.value.intelligent_tiering, var.bucket_defaults.intelligent_tiering, {})
  object_lock_configuration             = try(each.value.object_lock_configuration, var.bucket_defaults.object_lock_configuration, {})
  metric_configuration                  = try(each.value.metric_configuration, var.bucket_defaults.metric_configuration, [])
  inventory_configuration               = try(each.value.inventory_configuration, var.bucket_defaults.inventory_configuration, {})
  inventory_source_account_id           = try(each.value.inventory_source_account_id, var.bucket_defaults.inventory_source_account_id, null)
  inventory_source_bucket_arn           = try(each.value.inventory_source_bucket_arn, var.bucket_defaults.inventory_source_bucket_arn, null)
  inventory_self_source_destination     = try(each.value.inventory_self_source_destination, var.bucket_defaults.inventory_self_source_destination, false)
  analytics_configuration               = try(each.value.analytics_configuration, var.bucket_defaults.analytics_configuration, {})
  analytics_source_account_id           = try(each.value.analytics_source_account_id, var.bucket_defaults.analytics_source_account_id, null)
  analytics_source_bucket_arn           = try(each.value.analytics_source_bucket_arn, var.bucket_defaults.analytics_source_bucket_arn, null)
  analytics_self_source_destination     = try(each.value.analytics_self_source_destination, var.bucket_defaults.analytics_self_source_destination, false)
  object_lock_enabled                   = try(each.value.object_lock_enabled, var.bucket_defaults.object_lock_enabled, false)
  block_public_acls                     = try(each.value.block_public_acls, var.bucket_defaults.block_public_acls, false)
  block_public_policy                   = try(each.value.block_public_policy, var.bucket_defaults.block_public_policy, false)
  ignore_public_acls                    = try(each.value.ignore_public_acls, var.bucket_defaults.ignore_public_acls, false)
  restrict_public_buckets               = try(each.value.restrict_public_buckets, var.bucket_defaults.restrict_public_buckets, false)
  control_object_ownership              = try(each.value.control_object_ownership, var.bucket_defaults.control_object_ownership, false)
  object_ownership                      = try(each.value.object_ownership, var.bucket_defaults.object_ownership, "ObjectWriter")
  putin_khuylo                          = try(each.value.putin_khuylo, var.bucket_defaults.putin_khuylo, true)

}