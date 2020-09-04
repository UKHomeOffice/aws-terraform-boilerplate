terraform {
  backend "s3" {
    bucket = "pods-serverless-config-prod"
    key    = "terraform/state"
    region = "eu-west-1"
  }
}

module "prod" {
  source            = "../common"
  environment       = "prod"
  hostname          = "https://aaa.homeoffice.gov.uk"
  aaa-template      = "aaa"
  person-template   = "aaa"
  text-template     = "aaa"
  node-env          = "production"
  notify-key        = local.notify-key
  s3-config-bucket  = "pods-serverless-config-prod"
  region            = "eu-west-1"
}
