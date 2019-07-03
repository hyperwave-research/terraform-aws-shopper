
terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
  version = "~> 2.0"
}

resource "random_string" "test" {
  # Generate a random id for each deployment
  length           = 3
  override_special = "-"
}

resource "aws_s3_bucket" "test_tiingo"{
  bucket = "market-data-tiingo-fetch-${lower(var.environment)}-${lower(random_string.test.result)}"
  region = var.aws_region
}

module "tiingo_fetcher" {
  source = "../../../shopper"
  environment = var.environment
  region = var.aws_region
  S3_market_data_bucket = aws_s3_bucket.test_tiingo.bucket
  tiingo_api_key = var.tiingo_api_key
//    share_variables = {
//    version = var.module_version
//    environment = var.environment
//    loging_level = "DEBUG"
//    region = var.aws_region
//  }
//  s3_market_data_bucket = aws_s3_bucket.test_tiingo.bucket
//  tiingo_api_key = var.tiingo_api_key
//  trigger_sqs_arn = aws_sqs_queue.test_tiingo.arn
}

variable "module_version" {
  type = "string"
  description = "version of the module"
 }

variable "tiingo_api_key" {
  type = "string"
  description = "Tiingo api Key"
 }

variable "aws_region" {
  type = "string"
  description = "aws region where to deploy"
}

variable "environment"{
  type = "string"
  description = "Name of the environmenet"
}



output "s3_bucket_name" {
  value = aws_s3_bucket.test_tiingo.bucket
}

//output "lambda_function_name" {
//  value = module.tiingo_fetcher.function_name
//}

output "region" {
  value = var.aws_region
}