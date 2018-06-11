resource "aws_acm_certificate" "relifeted_info_apex" {
  domain_name       = "${var.zone}"
  validation_method = "DNS"

  tags {
    Name = "relifeted_info_apex"
  }
}

resource "aws_acm_certificate_validation" "relifeted_info_apex" {
  certificate_arn         = "${aws_acm_certificate.relifeted_info_apex.arn}"
  validation_record_fqdns = ["${aws_route53_record.relifeted_info_apex.fqdn}"]

  timeouts {
    create = "3m"
  }
}

resource "aws_route53_record" "relifeted_info_apex" {
  name    = "${aws_acm_certificate.relifeted_info_apex.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.relifeted_info_apex.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.relifeted_info.id}"
  records = ["${aws_acm_certificate.relifeted_info_apex.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate" "relifeted_info_wildcard" {
  domain_name       = "*.${var.zone}"
  validation_method = "DNS"

  tags {
    Name = "relifeted_info_wildcard"
  }
}

resource "aws_acm_certificate_validation" "relifeted_info_wildcard" {
  certificate_arn         = "${aws_acm_certificate.relifeted_info_wildcard.arn}"
  validation_record_fqdns = ["${aws_route53_record.relifeted_info_wildcard.fqdn}"]

  timeouts {
    create = "3m"
  }
}

resource "aws_route53_record" "relifeted_info_wildcard" {
  name    = "${aws_acm_certificate.relifeted_info_wildcard.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.relifeted_info_wildcard.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.relifeted_info.id}"
  records = ["${aws_acm_certificate.relifeted_info_wildcard.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate" "relifeted_info_apex_virginia" {
  provider          = "aws.virginia"
  domain_name       = "${var.zone}"
  validation_method = "DNS"

  tags {
    Name = "relifeted_info_apex_virginia"
  }
}

resource "aws_acm_certificate_validation" "relifeted_info_apex_virginia" {
  provider                = "aws.virginia"
  certificate_arn         = "${aws_acm_certificate.relifeted_info_apex_virginia.arn}"
  validation_record_fqdns = ["${aws_route53_record.relifeted_info_apex_virginia.fqdn}"]

  timeouts {
    create = "3m"
  }
}

resource "aws_route53_record" "relifeted_info_apex_virginia" {
  provider = "aws.virginia"
  name     = "${aws_acm_certificate.relifeted_info_apex_virginia.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.relifeted_info_apex_virginia.domain_validation_options.0.resource_record_type}"
  zone_id  = "${aws_route53_zone.relifeted_info.id}"
  records  = ["${aws_acm_certificate.relifeted_info_apex_virginia.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}

resource "aws_acm_certificate" "relifeted_info_wildcard_virginia" {
  provider          = "aws.virginia"
  domain_name       = "*.${var.zone}"
  validation_method = "DNS"

  tags {
    Name = "relifeted_info_wildcard_virginia"
  }
}

resource "aws_acm_certificate_validation" "relifeted_info_wildcard_virginia" {
  provider                = "aws.virginia"
  certificate_arn         = "${aws_acm_certificate.relifeted_info_wildcard_virginia.arn}"
  validation_record_fqdns = ["${aws_route53_record.relifeted_info_wildcard_virginia.fqdn}"]

  timeouts {
    create = "3m"
  }
}

resource "aws_route53_record" "relifeted_info_wildcard_virginia" {
  provider = "aws.virginia"
  name     = "${aws_acm_certificate.relifeted_info_wildcard_virginia.domain_validation_options.0.resource_record_name}"
  type     = "${aws_acm_certificate.relifeted_info_wildcard_virginia.domain_validation_options.0.resource_record_type}"
  zone_id  = "${aws_route53_zone.relifeted_info.id}"
  records  = ["${aws_acm_certificate.relifeted_info_wildcard_virginia.domain_validation_options.0.resource_record_value}"]
  ttl      = 60
}
