provider "aws" {
  version = "~> 2.32"
  region = var.region
}

data "aws_caller_identity" "current" {}