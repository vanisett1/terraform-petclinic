variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "The security group for the ALB"
  type        = string
}

variable "target_group_name" {
  description = "The name of the target group"
  type        = string
}

# variable "certificate_arn" {
#   description = "The ACM certificate ARN for HTTPS listener"
#   type        = string
# }
