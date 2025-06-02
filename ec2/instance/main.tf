data "aws_ami" "aws_linux" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-2023.0.20250117-kernel-6.1-x86_64"]
  }

 filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
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
    volume_size = 50
  }
  associate_public_ip_address = true

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  user_data = file(var.install_script)
  tags = merge(var.tags)
}
