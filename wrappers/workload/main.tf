module "wrapper_ecs_service" {
  source = "../../modules/workload/wrapper_ecs_service"

  metadata = var.metadata

  ecs_service_parameters = var.ecs_service_parameters
  ecs_service_defaults   = var.ecs_service_defaults

}