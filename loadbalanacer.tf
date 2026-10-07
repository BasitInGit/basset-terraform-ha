resource "aws_lb" "basset_ha_lb" {
  name                       = "basset-ha-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.basset_ec2_sg.id]
  subnets                    = var.subnet_ids
  enable_deletion_protection = false
  tags = {
    Environment = "dev"
  }
}

resource "aws_lb_target_group" "basset_ha_tg" {
  name        = "basset-ha-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    port                = 80
  }
}

resource "aws_lb_listener" "basset_listener" {
  load_balancer_arn = aws_lb.basset_ha_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.basset_ha_tg.arn
  }
}