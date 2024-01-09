include {
  path = find_in_parent_folders()
}
dependency "vpc" {
  config_path = "../amazon_vpc"
}

dependency "acm" {
  config_path = "../aws_certificate_manager"
}

inputs = {
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_id_1  = dependency.vpc.outputs.public_subnet1_id
  subnet_id_2  = dependency.vpc.outputs.public_subnet2_id
  alb_internal = false
  certificate_arn = dependency.acm.outputs.acm_arn
  priority_listener_rule  = "1"
}

terraform {
  source = "../../../../modules/aws_loadbalancer"

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