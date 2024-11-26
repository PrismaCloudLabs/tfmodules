variable "region" {
  type = string
}

variable "product_code" {
  type    = string
  default = "8acfvh6bldsr1ojb0oe3n8je5" #Amazon Linux 2023 AMI
}

variable "name" {
  type = string
}

variable "install_script" {
  type    = string
  default = "scripts/vulnerable.sh"
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "private_ip" {
  type    = string
  default = null
}

variable "vpc_subnet_name_search" {
  type    = string
  default = "hub-public-subnet"
}

variable "aws_security_group_id" {
  type = string
}

variable "tags" {
  type = map(any)
}