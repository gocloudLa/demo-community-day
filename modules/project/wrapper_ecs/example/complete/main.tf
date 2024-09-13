module "wrapper_ecs" {
  source = "../../"

  metadata = local.metadata
  project  = "example"


  ecs_parameters = {
    "00" = {
      cluster_settings = {
        name  = "containerInsights"
        value = "disabled"
      }
      default_capacity_provider_use_fargate = true
      fargate_capacity_providers = {
        FARGATE = {
          default_capacity_provider_strategy = {
            weight = 50
          }
        }
        FARGATE_SPOT = {
          default_capacity_provider_strategy = {
            weight = 50
          }
        }
      }
      autoscaling_capacity_providers = {}
    }
  }
  ecs_defaults = var.ecs_defaults
}