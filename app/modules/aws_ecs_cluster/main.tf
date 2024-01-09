// Create ECS cluster ECS 
resource "aws_ecs_cluster" "ecs" {
  name = "${var.env}-${var.project_name}"

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}