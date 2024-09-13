locals {
  create_ecr_repository_tmp = [
    for service_key, service in var.ecs_service_parameters : {
      for container_key, container in service.containers :
      "${service_key}-${container_key}" => {
        "service_key"                     = service_key
        "container_key"                   = container_key
        "repository_name"                 = try(container.repository_name, null)
        "repository_lifecycle_policy"     = try(container.repository_lifecycle_policy, null)
        "repository_image_tag_mutability" = try(container.repository_image_tag_mutability, "MUTABLE")
      }
      if(try(container.create_ecr_repository, true) == true && !can(container.image))
    }
  ]
  create_ecr_repository = merge(flatten(local.create_ecr_repository_tmp)...)
}

module "ecr" {
  source   = "terraform-aws-modules/ecr/aws"
  version  = "2.2.1"
  for_each = local.create_ecr_repository

  repository_name = lower(each.value.repository_name != null ? each.value.repository_name : "${local.common_name}-${each.value.service_key}-${each.value.container_key}")

  create_lifecycle_policy = true
  repository_lifecycle_policy = each.value.repository_lifecycle_policy != null ? each.value.repository_lifecycle_policy : jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  repository_image_tag_mutability = each.value.repository_image_tag_mutability
  repository_force_delete         = true
  tags                            = local.common_tags
}

output "ecr" {
  value = module.ecr
}