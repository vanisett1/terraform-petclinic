# Route Table for Public Subnets - Internet Access via IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pet_clinic_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-public-route-table"
  }
}

# Route Table Association for each Public Subnet
resource "aws_route_table_association" "public" {
  count     = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Table for Private Subnets - Internet Access via NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.pet_clinic_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.name}-private-route-table"
  }
}

# Route Table Association for each Private Subnet
resource "aws_route_table_association" "private" {
  count     = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Route Table for Secure Subnets - No Internet Access
resource "aws_route_table" "secure" {
  vpc_id = aws_vpc.pet_clinic_vpc.id

  tags = {
    Name = "${var.name}-secure-route-table"
  }
}

# Route Table Association for each Secure Subnet
resource "aws_route_table_association" "secure" {
  count     = length(aws_subnet.secure)
  subnet_id = aws_subnet.secure[count.index].id
  route_table_id = aws_route_table.secure.id
}
