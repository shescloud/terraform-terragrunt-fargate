include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/aws_roles"

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