output "ecs_service" {
  description = ""
  value       = try(module.wrapper_ecs_service.container_module, "")
}
