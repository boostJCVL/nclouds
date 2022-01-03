provider "aws" {
    region = "us-east-2"
}


terraform {
  backend "s3" {
    bucket = "carlos-nclouds-bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "carlos-tf-dynamodb"
  }
}