remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket           = "sonic-iac-testing"
    key              = "dev/${path_relative_to_include()}/terraform.tfstate"
    region           = "us-east-1"
    encrypt          = true
    dynamodb_table   = "terraform-state-lock"
  }
}

inputs = {
   region            = "us-east-1"
   project_name      = "sonic-iac-testing"
   env               = "dev"
   domain_name       = "shescloud.tech"
   host_headers      = "replace-by-your-domain"
   container_port    = "8080"
   
  tags = {
     ambiente        = "dev"
     projeto         = "sonic-iac-testing"
     plataforma      = "aws"
     gerenciado      = "terraform/terragrunt"
   }

}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "aws" {
  profile   = "default"
  region    = "us-east-1"
}

EOF
}