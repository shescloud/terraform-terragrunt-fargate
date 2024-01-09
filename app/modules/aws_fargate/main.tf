//Create ECR repositpry
resource "aws_ecr_repository" "ecs_cluster_ecr" {
  name = "${var.env}-${var.project_name}"

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}"
    },
    var.tags,
  )
}

//Create Route53 record 
resource "aws_route53_record" "record_sonic" {
  zone_id = "replace-by-your-hosted-zone-id"
  name    = "${var.host_headers}"
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_dns_name]
}

//Create a Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = "${var.env}-task-def-${var.project_name}"

  container_definitions = <<DEFINITION
[
  {
    "name":  "${var.env}-${var.project_name}" ,
    "image": "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.env}-${var.project_name}:latest",
    "essential": true,
    "memoryReservation": 64,
    "portMappings": [{
      "containerPort": ${var.container_port}
    }],
    "environment": [
      {
        "name": "ENV_PORT",
        "value": "${var.container_port}"
      },
      {
        "name": "ENVIRONMENT",
        "value": "${var.env}"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "ecs-${var.env}-${var.project_name}",
        "awslogs-region": "${var.region}",
        "awslogs-create-group": "true",
        "awslogs-stream-prefix": "${var.env}-${var.project_name}"
      }
    }
  }
]

DEFINITION


  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = var.ecs_role_arn
  execution_role_arn       = var.ecs_role_arn
  cpu                      = var.container_vcpu
  memory                   = var.container_memory
}


//Create a Fargate Service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.env}-${var.project_name}-service"
  cluster         = "${var.cluster_arn}"
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = var.instance_count
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.env}-${var.project_name}"
    container_port   = var.container_port
  }

  network_configuration {
    security_groups  = [aws_security_group.sg_ecs.id]
    subnets          = ["${var.subnet_id_1}", "${var.subnet_id_2}"]
    assign_public_ip = "false"
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 400

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}"
    },
    var.tags,
  )
}



///Create a SG for ECS
resource "aws_security_group" "sg_ecs" {
  name                   = "${var.env}-sg-ecs-${var.project_name}"
  description            = "SG for ECS"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = "true"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-sg-ecs-${var.project_name}"
  }
}

// SG rule to ALB
resource "aws_security_group_rule" "rule_ecs_alb" {
  description              = "from ALB"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_ecs.id
  source_security_group_id = var.sg_alb
}

// SG rule to ECS
resource "aws_security_group_rule" "in_ecs_nodes" {
  description              = "from ECS"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_ecs.id
  source_security_group_id = aws_security_group.sg_ecs.id
}