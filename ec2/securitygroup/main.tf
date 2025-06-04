resource "aws_security_group" "instance_sg" {
  name        = "${var.name}-sg"
  description = "Security Group for ${var.name}"
  vpc_id      = var.vpc_id

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

  tags = merge(var.tags, { Name = var.name })
}
