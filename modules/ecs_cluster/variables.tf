variable "ecs_cluster_name" {
  description = "Your AWS account ID"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ECS cluster's private DNS namespace"
}