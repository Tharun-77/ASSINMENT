output "vpc_id" {
  value = aws_vpc.prefect_vpc.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "vpc_cidr_block" {
  value = aws_vpc.prefect_vpc.cidr_block
}