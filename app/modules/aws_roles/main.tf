// Create policy
resource "aws_iam_policy" "ecs_service_policy" {
  name   = "${var.env}-${var.project_name}-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.ecs_service_role.json
}

// Create IAM Role
resource "aws_iam_role" "ecs_service_role" {
  name                  = "${var.env}-${var.project_name}-role"
  force_detach_policies = "true"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com",
          "codebuild.amazonaws.com",
          "codepipeline.amazonaws.com",
          "ecs.application-autoscaling.amazonaws.com",
          "ec2.amazonaws.com",
          "ecr.amazonaws.com"
        ]
      }
    }
  ]
}
EOF

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}"
    },
    var.tags,
  )
}

resource "aws_iam_policy_attachment" "ecs_service_role_atachment_policy" {
  name       = "${var.env}-${var.project_name}-policy-attachment"
  roles      = [aws_iam_role.ecs_service_role.name]
  policy_arn = aws_iam_policy.ecs_service_policy.arn
}