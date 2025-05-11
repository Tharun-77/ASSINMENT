#Creating a service for the ECS cluster

resource "aws_ecs_service" "prefect_worker" {
  name            = var.ecs_service_name
  #Here we mention which cluster and which Task
  cluster         = var.aws_ecs_cluster_id
  task_definition = var.aws_prefect_worker_arm
  
  launch_type     = "FARGATE"
  #Metion the number of tasks should run
  desired_count   = 1

  network_configuration {
  subnets          = var.subnet_ids
  security_groups  = [var.security_group_id]
  assign_public_ip = false
}
 
#We can add a load balancer but not mentioned in assignment

}
