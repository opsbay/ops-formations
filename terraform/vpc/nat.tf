resource "aws_security_group" "relifeted_info_nat" {
  name        = "${var.zone}.nat"
  description = "Allow nat traffic"
  vpc_id      = "${module.relifeted_info_vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "relifeted_info_nat" {
  source        = "../modules/aws_nat"
  name          = "${var.zone}"
  instance_type = "t2.nano"

  # instance_count         = "${length(data.aws_availability_zones.available.names)}"
  instance_count = "1"

  public_subnet_ids      = "${module.relifeted_info_vpc.public_subnets}"
  private_subnet_ids     = "${module.relifeted_info_vpc.private_subnets}"
  vpc_security_group_ids = ["${aws_security_group.relifeted_info_nat.id}"]
  az_list                = "${data.aws_availability_zones.available.names}"

  route_table_identifier = "private"
  aws_key_name           = "prod"
  ssh_bastion_user       = "ubuntu"
  ssh_bastion_host       = "${aws_instance.relifeted_info_bastion.public_ip}"
  aws_key_location       = "${file("${path.cwd}/../../.keys/relifeted_prod.pem")}"
}
