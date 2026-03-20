variable "env" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "private_asg_subnet_ids" {
  type = list(string)
}

variable "bastion_security_group_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "alb_security_group_id" {
    type = string
  
}

variable "target_group_arns" {
  type = list(string)
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type = string
}