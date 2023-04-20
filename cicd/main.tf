terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47"
    }
  }

  backend "s3" {
    bucket         = "clowd-haus-iac-us-east-1"
    key            = "api-gateway-ecs-razzle-dazzle/cicd/us-east-1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "clowd-haus-terraform-state"
    encrypt        = true
  }
}

provider "aws" {
  region = local.region

  # assume_role {
  #   role_arn     = "<TODO>"
  #   session_name = local.name
  # }
}

################################################################################
# Common Locals
################################################################################

data "aws_caller_identity" "current" {}

locals {
  name        = "api-gateway-ecs-razzle-dazzle"
  region      = "us-east-1"
  environment = "nonprod"

  account_id = data.aws_caller_identity.current.account_id
}

################################################################################
# Common Modules
################################################################################

module "tags" {
  source  = "clowdhaus/tags/aws"
  version = "~> 1.0"

  application = local.name
  environment = local.environment
  repository  = "https://github.com/clowdhaus/${local.name}"
}
