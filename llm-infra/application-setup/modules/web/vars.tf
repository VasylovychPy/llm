variable "monitoring_web_ami_id" {
  type = string
}

variable "web_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "public_subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "my_ip_cidr" {
  type = string
}

variable "llm_alb_dns" {
  type = string
}

variable "bastion_security_group_id" {
  type = string
}


variable "vpc_cidr" {
  type = string
}