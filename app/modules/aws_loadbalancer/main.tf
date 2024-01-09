// Create AWS ALB 
resource "aws_lb" "alb" {
  load_balancer_type         = "application"
  internal                   = var.alb_internal
  name                       = "${var.env}-alb-${var.project_name}"
  subnets                    = ["${var.subnet_id_1}", "${var.subnet_id_2}"]
  drop_invalid_header_fields = var.alb_drop_invalid_header_fields

  security_groups = [
    aws_security_group.alb.id,
  ]

  idle_timeout = 400

  dynamic "access_logs" {
    for_each = compact([var.lb_access_logs_bucket])

    content {
      bucket  = var.lb_access_logs_bucket
      prefix  = var.lb_access_logs_prefix
      enabled = true
    }
  }

  tags = {
    Name = "${var.env}-alb-${var.project_name}"
  }
}



//Create SG to ALB
resource "aws_security_group" "alb" {
  name        = "${var.env}-sg-alb-${var.project_name}"
  description = "SG for ECS ALB"
  vpc_id      = var.vpc_id

  revoke_rules_on_delete = "true"

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "${var.env}-alb-${var.project_name}"
  }
}

//Create default TG - ALB
resource "aws_alb_target_group" "target_group" {
  name        = "${var.env}-tg-default-alb"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      "Name" = "${var.env}-tg-${var.project_name}"
    },
    var.tags,
  )
}


// Create HTTPS listener
resource "aws_alb_listener" "listener_ssl" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
  depends_on = [
    aws_alb_target_group.target_group
  ]
}


resource "aws_alb_listener_rule" "ssl_listener_rule" {
  action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["default.${var.domain_name}"]
    }
  }

  priority     = var.priority_listener_rule
  listener_arn = aws_alb_listener.listener_ssl.arn

  depends_on = [
    aws_alb_listener.listener_ssl,
    aws_alb_target_group.target_group
  ]
}


// Create HTTP listener
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

} 