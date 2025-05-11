output "ecs_cluster_arn" {
  value = aws_ecs_cluster.prefect_cluster.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.prefect_cluster.id
}