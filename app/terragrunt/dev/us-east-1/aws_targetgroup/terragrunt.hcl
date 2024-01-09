include {
  path = find_in_parent_folders()
}
dependency "loadbalancer" {
  config_path = "../aws_loadbalancer"
}  
  dependency "vpc" {
  config_path = "../amazon_vpc"
}

dependency "acm" {
  config_path = "../aws_certificate_manager"
}

inputs = {
  vpc_id                  = dependency.vpc.outputs.vpc_id
  subnet_id_1             = dependency.vpc.outputs.public_subnet1_id
  subnet_id_2             = dependency.vpc.outputs.public_subnet2_id
  certificate_arn         = dependency.acm.outputs.acm_arn
  listener_ssl_arn        = dependency.loadbalancer.outputs.listener_ssl_arn
  priority_listener_rule  = "2"
  health_check_path       = "/"
}

terraform {
  source = "../../../../modules/aws_targetgroup"

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