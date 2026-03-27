resource "aws_iam_role" "ec2" {
  name = "${var.name}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "healthy" > /tmp/index.html
              nohup busybox httpd -f -p 8080 -h /tmp &
              EOF
  )
}

resource "aws_autoscaling_group" "this" {
  name                = "${var.name}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}
