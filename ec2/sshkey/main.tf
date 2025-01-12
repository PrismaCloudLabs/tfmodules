# // ------------------------------------------------------------------------------------
# // Create SSH Private Key
# 
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "sshkey-${var.region}"
  public_key = tls_private_key.pk.public_key_openssh
}

# // ------------------------------------------------------------------------------------
# // Store Private Key in AWS Secrets Manager
# 

resource "aws_secretsmanager_secret" "ssh_private_key" {
  name                    = "ssh_private_key-${var.region}"
  recovery_window_in_days = 0 # Allow immediate deletion of secrets manager so name can be re-used
}

resource "aws_secretsmanager_secret_version" "ssh_private_key_version" {
  secret_id     = aws_secretsmanager_secret.ssh_private_key.id
  secret_string = tls_private_key.pk.private_key_pem
}