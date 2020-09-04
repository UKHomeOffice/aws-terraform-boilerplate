terraform {
  backend "s3" {
    bucket = "serverless-config"
    key    = "terraform/account-state"
    region = "eu-west-1"
  }
}

module "notprod" {
  source          = "../account-common"
}