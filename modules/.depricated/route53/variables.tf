variable "zone_id" {
  description = "The Route53 Zone ID"
  type        = string
}

variable "subdomain" {
  description = "The subdomain for the application"
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "The ALB zone ID"
  type        = string
}
