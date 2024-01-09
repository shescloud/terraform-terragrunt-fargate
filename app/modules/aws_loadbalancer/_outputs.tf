output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}


output "alb_secgrp_id" {
  value = aws_security_group.alb.id
}


output "alb_arn_suffix" {
  value = trimspace(regex(".*loadbalancer/(.*)", aws_lb.alb.arn)[0])
}

output "listener_ssl_arn" {
  value = aws_alb_listener.listener_ssl.arn
}