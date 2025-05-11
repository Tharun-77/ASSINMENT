#Create a Task for ECS service

resource "aws_ecs_task_definition" "prefect_worker" {
  family                   = "dev-worker"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  #define the CPU and Memory to be allocated for tasks
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = var.aws_task_execution_role
  task_role_arn            = var.aws_task_execution_role



  container_definitions = jsonencode([
    {
      name      = "dev-worker-service"
      image     = "prefecthq/prefect:2-latest"
      essential = true
      command   = ["prefect", "worker", "start", "--pool", "ecs-work-pool"]

      environment = [
        {
          name  = "PREFECT_ACCOUNT_ID"
          value = var.prefect_account_id
        },
        {
          name  = "PREFECT_WORKSPACE_ID"
          value = var.prefect_workspace_id
        },
        {
          name  = "PREFECT_API_URL"
          value = var.prefect_api_url
        }
      ]

      #To Verify all the logs if any ERROR
      log_configuration = {
        log_driver = "awslogs"
        options = {
            awslogs-group         = "/ecs/prefect"
            awslogs-region        = "ap-south-1"  
            awslogs-stream-prefix = "ecs"
        }
    }
      #Giving the Secrect for API-KEY  
      secrets = [
        {
          name      = "PERFECT_API_KEY"
          valueFrom = var.secret_arn
        }
      ]

      tags = {
            Name = "prefect-worker-task"
        }
    }
  ])
}
