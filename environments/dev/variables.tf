variable "db_password" {
  description = "The database master password"
  type        = string
  sensitive   = true  # This marks the variable as sensitive
}
