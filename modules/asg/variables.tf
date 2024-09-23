variable "name" {
  description = "Name of the ASG"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "SSH Key name"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN for the Load Balancer"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2 instances"
  type        = string
}

# variable "docker_image" {
#   description = "Docker image to deploy"
#   type        = string
# }

variable "ecr_registry" {
  description = "ECR registry URL"
  type        = string
}

variable "ecr_repository" {
  description = "ECR repository name"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}


variable "vpc_id" {
  description = "The VPC ID for the ASG security group"
  type        = string
}
