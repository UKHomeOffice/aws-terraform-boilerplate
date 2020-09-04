terraform {
  backend "s3" {
    bucket = "pods-serverless-config"
    key    = "terraform/dev-state"
    region = "eu-west-1"
  }
}

module "dev" {
  source            = "../common"
  environment       = "dev"
  hostname          = "https://aaa.homeoffice.gov.uk"
  aaa-template   = "aaa"
  person-template   = "aaa"
  text-template     = "aaa"
  node-env          = "production"
  notify-key        = local.notify-key
  s3-config-bucket  = "pods-serverless-config"
  region            = "eu-west-1"
}