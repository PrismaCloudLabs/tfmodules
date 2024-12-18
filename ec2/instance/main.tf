data "aws_ami" "aws_linux" {
  most_recent = true
  filter {
    name   = "product-code"
    values = [ var.product_code ]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "tag:Name"
    values = [ var.vpc_subnet_name_search ]
  }
}

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

# // ------------------------------------------------------------------------------------
# // Deploy EC2 Instances
# 

resource "aws_instance" "this" {

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = var.instance_type 
  key_name               = aws_key_pair.kp.key_name
  subnet_id              = data.aws_subnets.this.ids[0]
  private_ip             = var.private_ip
  vpc_security_group_ids = [ var.aws_security_group_id ]
  iam_instance_profile   = var.instance_profile != "" ? var.instance_profile : null
  root_block_device {
    volume_size = 20
  }
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  user_data = file(var.install_script)
  tags = merge(var.tags, { Name = var.name })
}