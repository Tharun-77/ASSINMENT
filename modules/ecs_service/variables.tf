variable "ecs_service_name" {
  description = "Your AWS  service name"
  type        = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "aws_ecs_cluster_id" {
  type = string
}

variable "aws_prefect_worker_arm" {
  type = string
}