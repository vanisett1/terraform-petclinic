# Output the FQDN of the subdomain
output "subdomain_fqdn" {
  value       = aws_route53_record.subdomain.fqdn
  description = "The fully qualified domain name of the created subdomain"
}
