output "cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.ecs.arn
}