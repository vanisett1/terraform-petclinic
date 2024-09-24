terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.0.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Fetch Cloudflare Zone
data "cloudflare_zones" "zone" {
  filter {
    name = var.domain_name
  }
}

# DNS record for petclinic subdomain
resource "cloudflare_record" "petclinic" {
  zone_id = data.cloudflare_zones.zone.zones[0].id
  name    = var.subdomain_name
  value   = var.load_balancer_dns_name
  type    = "CNAME"
  ttl     = 1
  proxied = true  # Enables Cloudflare Proxy (For SSL and performance)
}

