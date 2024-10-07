variable "region" {
  type = string
}

variable "public_subnet_id" {
  type = list(any)
}

variable "instance_profile" {
  type = string
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

variable "aws_security_group_id" {
  type = string
}

variable "tags" {
  type = map(any)
}