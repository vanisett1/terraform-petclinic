resource "aws_vpc" "pet_clinic_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id            = aws_vpc.pet_clinic_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.pet_clinic_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-private-subnet-${count.index + 1}"
  }
}

# Secure Subnets
resource "aws_subnet" "secure" {
  count = length(var.secure_subnet_cidrs)

  vpc_id            = aws_vpc.pet_clinic_vpc.id
  cidr_block        = var.secure_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.name}-secure-subnet-${count.index + 1}"
  }
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.pet_clinic_vpc.id

  tags = {
    Name = "${var.name}-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public[*].id, 0)  # Placing NAT Gateway in the first public subnet

  tags = {
    Name = "${var.name}-nat-gateway"
  }
}
