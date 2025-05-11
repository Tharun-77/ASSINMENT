variable "aws_region" {
  default = "ap-south-1"
}

variable "ecs_cluster_name" {
  description = "Your AWS account ID"
  type        = string
  default     = "perfect-cluster"
}

variable "ecs_service_name" {
  description = "Your AWS  service name"
  type        = string
  default     = "prefect-worker-service"
}

variable "prefect_account_id" {
  type    = string
  default = "2b93aea3-b669-4f25-9ea9-e9505c82fb90"
}

variable "prefect_workspace_id" {
  type    = string
  default = "1f2dee7a-bc48-402e-83fc-c855a26f80d3"
}

variable "prefect_api_url" {
  type    = string
  default = "https://app.prefect.cloud/account/978e3113-f796-4649-bbf8-b54b0ff047b6/workspace/1f2dee7a-bc48-402e-83fc-c855a26f80d3"
}

variable "secret_arn" {
  type    = string
  default = "arn:aws:secretsmanager:ap-south-1:638417784865:secret:PERFECT_API_KEY-zqL70j"
}

variable "sg_name" {
  type    = string
  default = "ecs-service-sg"
}
