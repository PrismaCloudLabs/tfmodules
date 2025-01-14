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
  sshkey = "sshkey-${var.region}"
}

# // ------------------------------------------------------------------------------------
# // Deploy EC2 Instances
# 

resource "aws_instance" "this" {

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = var.instance_type 
  key_name               = var.keyname == "" ? local.sshkey : var.keyname
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