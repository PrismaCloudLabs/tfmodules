variable "name" {
  type = string
}

variable "vpc_id" {
  type    = string
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
  default = {
    Terraform = true
  }
}
