output "rds_endpoint" {
  description = "created rds database connection url"
  value       = aws_db_instance.rds.endpoint
}

output "rds_port" {
  description = "created rds database network access port"
  value       = aws_db_instance.rds.port
}

output "rds_arn" {
  description = "created rds database aws unqiue ARN"
  value       = aws_db_instance.rds.arn
}
