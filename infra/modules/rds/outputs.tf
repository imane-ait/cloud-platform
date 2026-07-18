output "db_endpoint" {
  description = "Endpoint de connexion RDS"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Nom de la base de données"
  value       = aws_db_instance.main.db_name
}

output "rds_security_group_id" {
  description = "Security group ID de RDS"
  value       = aws_security_group.rds.id
}
