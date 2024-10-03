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

variable "allowed_cidrs" {
  type = list(any)
  default = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ]
}

variable "allowed_ports" {
  type = list(any)
  default = [ 22, 80, 443, 9443, 3000, 8080 ]
}

variable "tags" {
  type = map(any)
}