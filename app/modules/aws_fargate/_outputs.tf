output "sg_ecs" {
  value = aws_security_group.sg_ecs.id
}

output "service_name" {
  value = aws_ecs_service.ecs_service.name
}

