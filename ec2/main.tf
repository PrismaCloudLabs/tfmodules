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
  vpc_security_group_ids = [ aws_security_group.instance_sg.id ]
  root_block_device {
    volume_size = 20
  }
  associate_public_ip_address = true
  iam_instance_profile = var.instance_profile

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  user_data = file(var.install_script)
  tags = var.tags

}

resource "aws_security_group" "instance_sg" {

  name        = "${var.name}-sg"
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpcId

  dynamic "ingress" {
    for_each = { for port in var.allowed_ports : port => port }

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidrs
      description = "Allow inbound traffic on port ${ingress.key}"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}