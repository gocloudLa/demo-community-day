module "bucket" {

  source = "../../"

  metadata = local.metadata
  project  = local.project

  bucket_parameters = {
    "example" = {
      # Bucket settings

      # force_destroy                         = false
      # acceleration_status                   = null
      # request_payer                         = null
      # website                               = {}
      # cors_rule                             = []
      # versioning                            = {}
      # logging                               = {}
      # grant                                 = []
      # owner                                 = {}
      # expected_bucket_owner                 = null
      # lifecycle_rule                        = []
      # replication_configuration             = {}
      # server_side_encryption_configuration  = {}
      # intelligent_tiering                   = {}
      # object_lock_configuration             = {}
      # metric_configuration                  = []
      # inventory_configuration               = {}
      # inventory_source_account_id           = null
      # inventory_source_bucket_arn           = null
      # inventory_self_source_destination     = false
      # analytics_configuration               = {}
      # analytics_source_account_id           = null
      # analytics_source_bucket_arn           = null
      # analytics_self_source_destination     = false
      # object_lock_enabled                   = false
      create_bucket = true

      # Bucket policies

      # attach_elb_log_delivery_policy        = false
      # attach_lb_log_delivery_policy         = false
      # attach_deny_insecure_transport_policy = false
      # attach_require_latest_tls_policy      = false
      # attach_policy                         = false
      # attach_public_policy                  = true
      # attach_inventory_destination_policy   = false
      # attach_analytics_destination_policy   = false
      # bucket_prefix                         = null
      # acl                                   = null
      # policy                                = null
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true


      # S3 Bucket Ownership Controls

      # control_object_ownership              = false
      object_ownership = "BucketOwnerEnforced"
    }
  }

  bucket_defaults = var.bucket_defaults
}