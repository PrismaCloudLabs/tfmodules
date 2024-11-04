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

locals {
  sshkeyName = var.sshkey_name ? var.sshkey_name : "sshkey-${var.region}"
}

# // ------------------------------------------------------------------------------------
# // Deploy EC2 Instances
# 

resource "aws_instance" "this" {

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = var.instance_type 
  key_name               = local.sshkeyName
  subnet_id              = data.aws_subnets.this[0].id
  private_ip             = var.private_ip
  vpc_security_group_ids = [ var.aws_security_group_id ]
  root_block_device {
    volume_size = 20
  }
  associate_public_ip_address = true
  iam_instance_profile = var.instance_profile

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  user_data = file(var.install_script)
  tags = merge(var.tags, { Name = var.name })
}