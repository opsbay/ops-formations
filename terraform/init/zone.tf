resource "aws_route53_zone" "relifeted_info" {
  name = "${var.zone}"

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "${var.zone}"
  }
}

resource "aws_route53_record" "relifeted_info-ns" {
  zone_id = "${aws_route53_zone.relifeted_info.zone_id}"
  name    = "${var.zone}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.relifeted_info.name_servers.0}",
    "${aws_route53_zone.relifeted_info.name_servers.1}",
    "${aws_route53_zone.relifeted_info.name_servers.2}",
    "${aws_route53_zone.relifeted_info.name_servers.3}",
  ]
}

resource "aws_route53_zone" "private_zone" {
  name = "${var.private_zone}"

  tags {
    Name = "${var.zone}"
  }
}

resource "aws_route53_record" "private_zone-ns" {
  zone_id = "${aws_route53_zone.private_zone.zone_id}"
  name    = "${var.private_zone}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.private_zone.name_servers.0}",
    "${aws_route53_zone.private_zone.name_servers.1}",
    "${aws_route53_zone.private_zone.name_servers.2}",
    "${aws_route53_zone.private_zone.name_servers.3}",
  ]
}
