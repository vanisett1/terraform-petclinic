variable "domain_name" {
  description = "The domain name for which the ACM certificate is issued"
  type        = string
}

variable "zone_id" {
  description = "The Route53 Zone ID"
  type        = string
}
