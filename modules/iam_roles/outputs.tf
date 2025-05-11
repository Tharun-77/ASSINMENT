output "aws_task_execution_role" {
  description = "just a role"
  value = aws_iam_role.ecs_task_execution_role.arn
}