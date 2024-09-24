variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  type = string
}

variable "subdomain_name" {
  type = string
}

variable "load_balancer_dns_name" {
  type = string
}
