variable "name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID for the Load Balancer security group"
  type        = string
}


variable "public_subnets" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID for the Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the Target Group"
  type        = string
}


