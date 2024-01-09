include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/aws_ecs_cluster"

  extra_arguments "custom_vars" {
    commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh"
    ]
  }
}