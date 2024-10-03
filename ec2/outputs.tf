output "publicIPs" {
  value = aws_instance.this.public_ip
}

output "securityGroupIds" {
  value = aws_security_group.instance_sg.id
}

output "sshKeyName" {
 value = aws_key_pair.kp.key_name
}

output "sshPrivateKey" {
  value     = tls_private_key.pk.private_key_pem
  sensitive = true
}