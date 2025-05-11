#IAM Role for ECS Tasks (Execution Role)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "prefect-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach the AWS managed policy for ECS execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Custom Policy to access Secrets Manager
resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "SecretsManagerReadPolicy"
  description = "Allows ECS Task to read a secret from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Sid: "ReadSecretsManager",
        Effect: "Allow",
        Action: [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource: var.aws_prefect_worker_arm
      }
    ]
  })
}

#Attach the custom Secrets Manager policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "secrets_access_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets_manager_read_policy.arn
}
