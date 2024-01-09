//Create Target Group
resource "aws_alb_target_group" "target_group" {
  name        = "${var.env}-tg-${var.project_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    matcher             = "200-299"
    path                = var.health_check_path
    port                = var.container_port
    protocol            = "HTTP"
    unhealthy_threshold = 8
    timeout             = 10
  }


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



// Create HTTPS L
resource "aws_alb_listener_rule" "ssl_listener_rule" {
  action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["${var.host_headers}"]
    }
  }

  priority     = var.priority_listener_rule
  listener_arn = var.listener_ssl_arn

}
