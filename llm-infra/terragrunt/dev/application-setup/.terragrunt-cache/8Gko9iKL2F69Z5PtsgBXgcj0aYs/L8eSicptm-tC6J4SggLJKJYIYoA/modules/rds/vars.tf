variable "env" {
    description = "Environment variable"
  type = string
}

variable "common_tags" {
    description = "Tags to all recources"
  type = map(string)
}

variable "vpc_id" {
    description = "VPC where all resources"
  type = string
}

variable "private_rds_subnet_ids" {
    description = "Private subnets for RDS"
  type = list(string)
}

variable "web_security_group_id" {
    description = "Security groups that allows traffic"
  type = string
}

variable "db_username" {
    description = "Users name for Database"
  type = string
}

variable "db_name" {
    description = "Name of Database"
  type = string
}

variable "db_password" {
  type = string
}
