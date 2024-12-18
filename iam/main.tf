
resource "random_string" "this" {
  lower   = true
  upper   = false
  special = false
  length  = 6
}

resource "aws_iam_role" "ec2_s3_cloudinit_role" {
  name = "ec2_s3_cloudinit_role_${random_string.this.id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
  tags = {}
}

resource "aws_iam_instance_profile" "ec2_s3_cloudinit_profile" {
  name = "ec2_ecr_instance_profile_${random_string.this.id}"
  role = aws_iam_role.ec2_s3_cloudinit_role.name
  tags = {
    Name = "ec2_s3_cloudinit_profile_${random_string.this.id}"
  }
}