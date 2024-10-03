variable "vpcId" {
  type = string
}

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
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "private_ip" {
  type    = string
  default = null
}

variable "allowed_cidrs" {
  type = list(any)
}

variable "allowed_ports" {
  type = list(any)
}

variable "tags" {
  type = map(any)
}