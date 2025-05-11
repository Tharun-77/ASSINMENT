variable "sg_name" {
  type = string
  default = "ecs-service-sg"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}