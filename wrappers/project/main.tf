module "wrapper_alb" {
  source = "../../modules/project/wrapper_alb"

  metadata = var.metadata
  project  = var.project

  alb_parameters       = var.alb_parameters
  alb_defaults         = var.alb_defaults
}

module "wrapper_ecs" {
  source = "../../modules/project/wrapper_ecs"

  metadata = var.metadata
  project  = var.project

  ecs_parameters = var.ecs_parameters
  ecs_defaults   = var.ecs_defaults
}

module "wrapper_rds" {
  source = "../../modules/project/wrapper_rds"

  metadata = var.metadata
  project  = var.project

  rds_parameters = var.rds_parameters
  rds_defaults   = var.rds_defaults
}

module "wrapper_bucket" {
  source = "../../modules/project/wrapper_bucket"

  metadata = var.metadata
  project  = var.project

  bucket_parameters = var.bucket_parameters
  bucket_defaults   = var.bucket_defaults
}