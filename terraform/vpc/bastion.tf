data "aws_ami" "bastion" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:Name"
    values = ["bastion"]
  }

  most_recent = true
}

data "aws_iam_policy_document" "bastion_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "route53:*",
    ]

    resources = [
      "*",
    ]
  }
}

module "bastion_role" {
  source = "../modules/aws_ec2_role"

  name   = "bastion"
  policy = "${data.aws_iam_policy_document.bastion_role_policy.json}"
}

resource "aws_security_group" "relifeted_info_bastion" {
  name = "bastion"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${module.relifeted_info_vpc.vpc_id}"

  tags {
    Name = "${var.zone}-bastion"
  }
}

resource "aws_security_group_rule" "relifeted_info_bastion_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["${module.relifeted_info_vpc.vpc_cidr_block}"]

  security_group_id = "${aws_security_group.relifeted_info_bastion.id}"
}

data "external" "external" {
  program = ["python", "${path.cwd}/../../scripts/get-external-ip.py"]
}

resource "aws_security_group" "relifeted_info_bastion_custom" {
  name = "bastion_custom"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${module.relifeted_info_vpc.vpc_id}"

  tags {
    Name = "${var.zone}-bastion-custom"
  }
}

resource "aws_security_group_rule" "relifeted_info_bastion_custom_ted" {
  security_group_id = "${aws_security_group.relifeted_info_bastion_custom.id}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${data.external.external.result.ip}/32"]
  description       = "Ted"
}

resource "aws_instance" "relifeted_info_bastion" {
  ami           = "${data.aws_ami.bastion.id}"
  instance_type = "t2.nano"
  key_name      = "prod"

  vpc_security_group_ids = [
    "${aws_security_group.relifeted_info_bastion.id}",
    "${aws_security_group.relifeted_info_bastion_custom.id}",
  ]

  subnet_id                   = "${module.relifeted_info_vpc.public_subnets[0]}"
  associate_public_ip_address = true
  source_dest_check           = false
  iam_instance_profile        = "${lookup(module.bastion_role.aws_iam_instance_profile, "profile.name")}"

  user_data = "${file("files/bastion_bootstrap")}"

  tags {
    Name = "${var.zone}-bastion"
  }
}

resource "aws_route53_record" "relifeted_info_bastion" {
  zone_id = "${data.aws_route53_zone.relifeted_info.zone_id}"
  name    = "bn"
  type    = "A"
  ttl     = "60"

  records = [
    "${aws_instance.relifeted_info_bastion.public_ip}",
  ]
}
