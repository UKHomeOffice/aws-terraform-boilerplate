terraform {
  backend "s3" {
    bucket = "pods-serverless-config-prod"
    key    = "terraform/account-state"
    region = "eu-west-1"
  }
}

module "prod" {
  source          = "../account-common"
}