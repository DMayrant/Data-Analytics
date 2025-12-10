resource "aws_security_group" "main_sg" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(local.common_tags, {
    Name = "VPC-EC2-SG"
  })
}

resource "aws_security_group_rule" "allow_ssh_access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.my_ip]  # <- Only your IP (NO 0.0.0.0/0)
  security_group_id = aws_security_group.main_sg.id
  description       = "Allow SSH from my IP"
}

resource "aws_security_group_rule" "allow_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]  # HTTP can be public
  security_group_id = aws_security_group.main_sg.id
  description       = "Allow public HTTP"
}

resource "aws_security_group_rule" "main_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main_sg.id
}

resource "aws_security_group" "aurora_sg" {
  name   = "aurora-sg"
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_security_group_rule" "aurora_ingress_from_ec2" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main_sg.id
  security_group_id        = aws_security_group.aurora_sg.id
  description              = "Allow EC2 to connect to Aurora"
}

resource "aws_security_group_rule" "aurora_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.aurora_sg.id
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for PUBLIC load balancer"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # allow public access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
