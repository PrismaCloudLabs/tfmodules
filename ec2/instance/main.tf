data "aws_ami" "aws_linux" {
  most_recent = true
  filter {
    name   = "product-code"
    values = ["8acfvh6bldsr1ojb0oe3n8je5"]
  }
}

# // ------------------------------------------------------------------------------------
# // Deploy EC2 Instances
# 

resource "aws_instance" "this" {

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = var.instance_type 
  key_name               = "sshkey-${var.region}"
  subnet_id              = var.public_subnet_id[0]
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