resource "aws_security_group" "ecs_service_sg" {
  name        = var.sg_name
  description = "Security group for ECS Fargate Prefect Worker"
  vpc_id      =  var.vpc_id

  # Allow all outbound traffic (needed for internet/NAT access)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow traffic within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = "prefect-ecs"
  }
}
