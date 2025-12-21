terraform {
  required_version = "> 1.3"

  backend "s3" {}

  required_providers {
    sops = {
      source = "carlpett/sops"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "sops" {}

provider "aws" {
  region     = data.sops_file.secret_vars.data["s3_region"]
  access_key = data.sops_file.secret_vars.data["s3_access_key"]
  secret_key = data.sops_file.secret_vars.data["s3_secret_key"]
}
