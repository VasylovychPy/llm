variable "region" {
    description="Region where resource will be created"
    type= string
}

variable "env" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
    type              = string
  }))
}

variable "vpc_name" {
  type = string
}