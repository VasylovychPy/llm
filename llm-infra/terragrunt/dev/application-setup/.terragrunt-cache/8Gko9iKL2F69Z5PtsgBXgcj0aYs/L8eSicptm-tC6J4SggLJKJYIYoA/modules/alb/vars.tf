variable "env" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "web_security_group_id" {
  type = string
  
}
