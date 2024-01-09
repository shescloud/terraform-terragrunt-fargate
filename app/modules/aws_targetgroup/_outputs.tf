output "tg_alb_arn" {
  value = aws_alb_target_group.target_group.arn
}

output "tg_arn_suffix" {
  value = regex(".*:(.*)", aws_alb_target_group.target_group.arn)[0]
}