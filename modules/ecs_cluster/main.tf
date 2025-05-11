# creating an ECS cluster with a service
resource "aws_ecs_cluster" "prefect_cluster" {
  name = var.ecs_cluster_name

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.prefect_namespace.arn
  }

  tags = {
    Name = var.ecs_cluster_name
  }
}

# Private DNS Namespace for Service Discovery
resource "aws_service_discovery_private_dns_namespace" "prefect_namespace" {
  name        = "default.prefect.local"
  description = "Private DNS namespace for ECS services"
  vpc         = var.vpc_id  

  tags = {
    Name = "prefect-ecs"
  }
}
