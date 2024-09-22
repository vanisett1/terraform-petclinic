output "vpc_id" {
  value = aws_vpc.pet_clinic_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "secure_subnets" {
  value = aws_subnet.secure[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
