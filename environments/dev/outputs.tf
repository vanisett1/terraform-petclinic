output "rds_cluster_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.endpoint
  description = "The endpoint for the Aurora DB cluster"
}

output "rds_cluster_reader_endpoint" {
  value       = aws_rds_cluster.aurora_cluster.reader_endpoint
  description = "The reader endpoint for the Aurora DB cluster"
}
