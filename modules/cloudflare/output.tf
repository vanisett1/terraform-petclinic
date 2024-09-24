# outputs.tf for Cloudflare module
output "zone_id" {
  description = "The Cloudflare Zone ID for the given domain."
  value       = data.cloudflare_zones.zone.zones[0].id
}

output "cloudflare_dns_name" {
  description = "The full DNS name (subdomain) created in Cloudflare."
  value       = cloudflare_record.petclinic.name
}

output "cloudflare_dns_value" {
  description = "The DNS value pointing to the application (Load Balancer DNS)."
  value       = cloudflare_record.petclinic.value
}

output "cloudflare_dns_proxied" {
  description = "Whether the DNS record is proxied by Cloudflare."
  value       = cloudflare_record.petclinic.proxied
}
