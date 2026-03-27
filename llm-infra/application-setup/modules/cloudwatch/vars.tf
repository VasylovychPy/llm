
variable "env" {
  type    = string
}

variable "sns_email" {
  type = string
}

variable "rds_instance_id" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}