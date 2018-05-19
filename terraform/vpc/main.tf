terraform {
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

data "aws_route53_zone" "relifeted_info" {
  name = "${var.zone}."
}
