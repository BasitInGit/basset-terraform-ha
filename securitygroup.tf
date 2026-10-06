resource "aws_security_group" "basset_ec2_sg" {
  name        = "basset-ec2-sg"
  description = "security group for bassset application"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "basset_ec2_ssh" {
  type              = "ingress"
  description       = "SSH access"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.basset_ec2_sg.id
}

resource "aws_security_group_rule" "basset_ec2_http" {
  type              = "ingress"
  description       = "HTTP access"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.basset_ec2_sg.id
}

resource "aws_security_group_rule" "basset_ec2_outbound" {
  type              = "egress"
  description       = "outbound access"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.basset_ec2_sg.id
}