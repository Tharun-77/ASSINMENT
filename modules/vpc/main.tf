data "aws_availability_zones" "available" {}

resource "aws_vpc" "prefect_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name
  }
}

#Public Subnets
resource "aws_subnet" "public_subnets" {
  count                   = 3
  vpc_id                  = aws_vpc.prefect_vpc.id
  cidr_block              = cidrsubnet("10.0.0.0/20", 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.vpc_name
  }
}

#Private Subnets
resource "aws_subnet" "private_subnets" {
  count             = 3
  vpc_id            = aws_vpc.prefect_vpc.id
  cidr_block        = cidrsubnet("10.0.100.0/20", 4, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = var.vpc_name
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prefect_vpc.id

  tags = {
    Name = var.vpc_name
  }
}

#Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = var.vpc_name
  }
}

# NAT Gateway (single, in first public subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = var.vpc_name
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prefect_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.vpc_name
  }
}

#Associate Public Subnets
resource "aws_route_table_association" "public_assoc" {
  count          = 3
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

#Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.prefect_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.vpc_name
  }
}

#Associate Private Subnets
resource "aws_route_table_association" "private_assoc" {
  count          = 3
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
