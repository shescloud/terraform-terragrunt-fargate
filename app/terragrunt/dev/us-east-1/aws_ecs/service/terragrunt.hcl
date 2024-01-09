include {
  path = find_in_parent_folders()
}
dependency "loadbalancer" {
  config_path = "../../aws_loadbalancer"
}  
  dependency "vpc" {
  config_path = "../../amazon_vpc"
}
dependency "role" {
  config_path = "../../aws_roles"
}

dependency "targetgroup" {
  config_path = "../../aws_targetgroup"
}

dependency "cluster" {
  config_path = "../cluster"
}

inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  subnet_id_1           = dependency.vpc.outputs.private_subnet1_id
  subnet_id_2           = dependency.vpc.outputs.private_subnet2_id
  alb_dns_name          = dependency.loadbalancer.outputs.alb_dns_name
  sg_alb                = dependency.loadbalancer.outputs.alb_secgrp_id
  target_group_arn      = dependency.targetgroup.outputs.tg_alb_arn
  cluster_arn           = dependency.cluster.outputs.cluster_arn
  ecs_role_arn          = dependency.role.outputs.ecs_role_arn
  instance_count        = "1"
  container_vcpu        = "512"
  container_memory      = "1024"
  aws_account_id        = "replace-by-your-account-id"
}

terraform {
  source = "../../../../../modules/aws_fargate"

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