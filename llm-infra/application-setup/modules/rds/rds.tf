resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&()*+,-.:;<=>?[]^_{|}"
}

resource "aws_secretsmanager_secret" "rds" {
  name        = "${var.env}-rds-credentials-v2"
  description = "RDS PostgreSQL credentials for ${var.env}"

  tags = merge(var.common_tags, {
    Name = "${var.env}-rds-credentials"
  })
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_rds_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.env}-db-subnet-group"
  })
}

resource "aws_security_group" "rds" {
  name        = "${var.env}-rds-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from ASG security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.web_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-rds-sg"
  })
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.env}-postgres"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  port                   = 5432
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username            = var.db_username
  password            = var.db_password
  db_name             = var.db_name
  publicly_accessible = false

  skip_final_snapshot = true

  tags = merge(var.common_tags, {
    Name = "${var.env}-postgres"
  })
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
    host     = aws_db_instance.postgres.address
    port     = aws_db_instance.postgres.port
    dbname   = var.db_name
  })
}

resource "aws_iam_policy" "read_rds_secret" {
  name        = "${var.env}-read-rds-secret"
  description = "Allow reading RDS secret from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.rds.arn
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.env}-read-rds-secret"
  })
}