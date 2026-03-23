output "db_instance_id" {
  description = "RDS instance id"
  value       = aws_db_instance.postgres.id
}

output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "RDS port"
  value       = aws_db_instance.postgres.port
}

output "db_security_group_id" {
  description = "Security group for RDS"
  value       = aws_security_group.rds.id
}

output "db_subnet_group" {
  description = "DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "secret_arn" {
  description = "Secrets Manager ARN with DB credentials"
  value       = aws_secretsmanager_secret.rds.arn
}