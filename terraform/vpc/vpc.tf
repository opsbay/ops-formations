locals {
  relifeted_info_cidr_block = "10.0.0.0/16"
}

module "relifeted_info_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.zone}"
  cidr = "${local.relifeted_info_cidr_block}"

  azs = ["${data.aws_availability_zones.available.names}"]

  enable_nat_gateway       = false
  enable_vpn_gateway       = false
  enable_dns_hostnames     = true
  enable_dhcp_options      = true
  dhcp_options_ntp_servers = ["169.254.169.123"]

  dhcp_options_tags {
    Name = "${var.zone}"
  }

  enable_dynamodb_endpoint = true
  enable_s3_endpoint       = true

  vpc_tags {
    Name = "${var.zone}"
  }

  public_subnets = [
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 0)}",
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 1)}",
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 2)}",
  ]

  public_route_table_tags {
    Name = "${var.zone}"
    Role = "Public"
  }

  public_subnet_tags {
    Name = "${var.zone}"
    Role = "Public"
  }

  private_subnets = [
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 4)}",
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 5)}",
    "${cidrsubnet(local.relifeted_info_cidr_block, 4, 6)}",
  ]

  private_route_table_tags {
    Name = "${var.zone}"
    Role = "Private"
  }

  private_subnet_tags {
    Name = "${var.zone}"
    Role = "Private"
  }

  tags {
    Terraform = "true"
    Vpc       = "${var.zone}"
  }
}
