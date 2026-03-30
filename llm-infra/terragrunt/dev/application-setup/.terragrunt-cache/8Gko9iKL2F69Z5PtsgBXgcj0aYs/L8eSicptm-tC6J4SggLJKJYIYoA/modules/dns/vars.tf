variable "domain_name" {
    type = string
  
}
variable "env" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "web_public_ip" {
  type = string
}

variable "vpc_id" {
  type = string
}
