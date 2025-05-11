output "ecs_tasks" {
   value = aws_ecs_task_definition.prefect_worker.arn
}

output "prefect_worker_arn" {
  value = aws_ecs_task_definition.prefect_worker.arn
}