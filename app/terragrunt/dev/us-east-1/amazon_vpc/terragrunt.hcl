include {
  path = find_in_parent_folders()
}

inputs = {
    vpc_cidr_block              = "172.35.0.128/25"
    public_subnet1_cidr_block   = "172.35.0.128/27"
    public_subnet2_cidr_block   = "172.35.0.160/27"
    private_subnet1_cidr_block  = "172.35.0.192/27"
    private_subnet2_cidr_block  = "172.35.0.224/27"

    availability_zone1 = "us-east-1a"
    availability_zone2 = "us-east-1b"

}

terraform {
  source = "../../../../modules/amazon_vpc"

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