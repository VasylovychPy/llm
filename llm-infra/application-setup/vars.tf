variable "env" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "asg_desired_capacity" {
  type = number
  
}

variable "asg_max_size" {
  type = number
  
}

variable "asg_min_size" {
  type = number
  
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "bastion_ami_id" {
  type = string
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "my_ip_cidr" {
  type = string
}

variable "web_ami_id" {
  type = string
}

variable "web_instance_type" {
  type = string
}

variable "sns_email" {
  type = string
}
 variable "db_password" {
   type = string
 }


