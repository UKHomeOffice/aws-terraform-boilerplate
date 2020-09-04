variable "environment" {}
variable "hostname" {}
variable "aaa-template" {}
variable "person-template" {}
variable "text-template" {}
variable "node-env" {}
variable "notify-key" {}
variable "s3-config-bucket" {}
variable "region" {}

locals {
  environment = var.environment
  region = var.region
  ffprobe_arn = aws_lambda_function.ffprobe-checker.invoke_arn
  gateway_arn = aws_lambda_function.gateway-lambda.invoke_arn
}