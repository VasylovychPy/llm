
variable "env" {
  type    = string
}

variable "sns_email" {
  type = string
}

variable "rds_instance_identifier" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "common_tags" {
  type = map(string)
}