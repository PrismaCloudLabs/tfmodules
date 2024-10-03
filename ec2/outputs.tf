output "publicIPs" {
  value = aws_instance.this.public_ip
}

output "securityGroupIds" {
  value = aws_security_group.instance_sg.id
}