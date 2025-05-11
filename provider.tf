provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket         = "prefect-bucket-47"
    key            = "ecs/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "Prefect_dynamoDb_lock"
  }
}