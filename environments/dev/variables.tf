variable "db_password" {
  description = "The database master password"
  type        = string
  sensitive   = true # This marks the variable as sensitive
}

variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}