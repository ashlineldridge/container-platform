// VPC
resource "aws_vpc" "cluster_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

// Internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.cluster_vpc.id
}

// Elastic IP for NAT gateway in AZA
resource "aws_eip" "nat_gateway_eip_a" {
  vpc = true
}

// Elastic IP for NAT gateway in AZB
resource "aws_eip" "nat_gateway_eip_b" {
  // Only provision a NAT in each AZ if production_mode is enabled
  count = var.production_mode ? 1 : 0
  vpc = true
}

// Elastic IP for NAT gateway in AZC
resource "aws_eip" "nat_gateway_eip_c" {
  // Only provision a NAT in each AZ if production_mode is enabled
  count = var.production_mode ? 1 : 0
  vpc = true
}

// NAT gateway in AZA
resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_gateway_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id
}

// NAT gateway in AZB
resource "aws_nat_gateway" "nat_gateway_b" {
  // Only provision a NAT in each AZ if production_mode is enabled
  count = var.production_mode ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id
}

// NAT gateway in AZC
resource "aws_nat_gateway" "nat_gateway_c" {
  // Only provision a NAT in each AZ if production_mode is enabled
  count = var.production_mode ? 1 : 0
  allocation_id = aws_eip.nat_gateway_eip_c.id
  subnet_id     = aws_subnet.public_subnet_c.id
}

// Public subnet in AZA
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.name_prefix}-public-subnet-a"
  }
}

// Public subnet in AZB
resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.public_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.name_prefix}-public-subnet-b"
  }
}

// Public subnet in AZC
resource "aws_subnet" "public_subnet_c" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.public_subnet_c_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.name_prefix}-public-subnet-c"
  }
}

// Private subnet in AZA
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.name_prefix}-private-subnet-a"

    // Let EKS know to create internal ELBs here
    "kubernetes.io/role/internal-elb" = 1
  }
}

// Private subnet in AZB
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.name_prefix}-private-subnet-b"

    // Let EKS know to create internal ELBs here
    "kubernetes.io/role/internal-elb" = 1
  }
}

// Private subnet in AZC
resource "aws_subnet" "private_subnet_c" {
  vpc_id            = aws_vpc.cluster_vpc.id
  cidr_block        = var.private_subnet_c_cidr
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.name_prefix}-private-subnet-c"

    // Let EKS know to create internal ELBs here
    "kubernetes.io/role/internal-elb" = 1
  }
}

// Route table for all public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cluster_vpc.id

  // Forward all non-local traffic to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

// Route table for the private subnet in AZA
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.cluster_vpc.id

  // Forward all non-local traffic to the NAT gateway in AZA
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }
}

// Route table for the private subnet in AZB
resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.cluster_vpc.id

  // Forward all non-local traffic to the NAT gateway in AZB if
  // we've provisioned multiple NATs otherwise to the NAT in AZA
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.production_mode ?
      aws_nat_gateway.nat_gateway_b.id :
      aws_nat_gateway.nat_gateway_a.id
  }
}

// Route table for the private subnet in AZC
resource "aws_route_table" "private_route_table_c" {
  vpc_id = aws_vpc.cluster_vpc.id

  // Forward all non-local traffic to the NAT gateway in AZC if
  // we've provisioned multiple NATs otherwise to the NAT in AZA
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.production_mode ?
    aws_nat_gateway.nat_gateway_b.id :
    aws_nat_gateway.nat_gateway_a.id
  }
}

// Route table association for public subnet in AZA
resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

// Route table association for public subnet in AZB
resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

// Route table association for public subnet in AZC
resource "aws_route_table_association" "public_route_table_association_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

// Route table association for private subnet in AZA
resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

// Route table association for private subnet in AZB
resource "aws_route_table_association" "private_route_table_association_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}

// Route table association for private subnet in AZC
resource "aws_route_table_association" "private_route_table_association_c" {
  subnet_id      = aws_subnet.private_subnet_c.id
  route_table_id = aws_route_table.private_route_table_c.id
}
