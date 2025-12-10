resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-"
  image_id      = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"

  # EC2 should live in private subnets behind the ALB
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.main_sg.id]
  }

tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags, {
      Name = "App-EC2-${var.env}"
    })
  }
}