# EC2 Complete
output "ec2_instance_id" {
  description = "The ID of the instance"
  value       = try(module.ec2_instance[0].id, "")
}

output "ec2_instance_arn" {
  description = "The ARN of the instance"
  value       = try(module.ec2_instance[0].arn, "")
}
