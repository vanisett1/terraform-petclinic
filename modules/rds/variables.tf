variable "private_subnets" {
  description = "List of private subnets for the RDS cluster"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the RDS cluster will be deployed"
  type        = string
}

variable "ec2_security_group_id" {
  description = "The security group ID for the EC2 instances to allow traffic"
  type        = string
}

variable "database_name" {
  description = "Name of the database to be created in the RDS cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for the RDS cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for the RDS cluster"
  type        = string
  sensitive   = true
}


