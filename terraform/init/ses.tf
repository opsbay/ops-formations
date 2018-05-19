resource "aws_ses_domain_identity" "relifeted_info" {
  provider = "aws.virginia"
  domain   = "${var.zone}"
}

resource "aws_route53_record" "relifeted_info_verification_record" {
  zone_id = "${aws_route53_zone.relifeted_info.zone_id}"
  name    = "_amazonses"
  type    = "TXT"
  ttl     = "60"
  records = ["${aws_ses_domain_identity.relifeted_info.verification_token}"]
}

resource "aws_route53_record" "relifeted_info_MX" {
  zone_id = "${aws_route53_zone.relifeted_info.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "60"
  records = ["10 inbound-smtp.us-east-1.amazonaws.com."]
}

resource "aws_ses_receipt_rule_set" "main" {
  provider      = "aws.virginia"
  rule_set_name = "main-receipt-rules"
}

resource "aws_ses_active_receipt_rule_set" "main" {
  provider      = "aws.virginia"
  rule_set_name = "${aws_ses_receipt_rule_set.main.rule_set_name}"
}

# 收信用的 bucket
resource "aws_s3_bucket" "admin_inbox" {
  provider = "aws.virginia"
  bucket   = "${var.zone}-admin-inbox"

  region = "us-east-1"
  acl    = "private"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GiveSESPermissionToWriteEmail",
      "Effect": "Allow",
      "Principal": {
        "Service": "ses.amazonaws.com"
      },
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::${var.zone}-admin-inbox",
        "arn:aws:s3:::${var.zone}-admin-inbox/*"
      ]
    }
  ]
}
POLICY

  tags {
    Name = "${var.zone}-admin-inbox"
  }
}

resource "aws_ses_receipt_rule" "relifeted_info_admin" {
  provider      = "aws.virginia"
  name          = "${var.zone}-admin-rule"
  rule_set_name = "${aws_ses_receipt_rule_set.main.rule_set_name}"

  recipients = [
    "admin@${var.zone}",
    "administrator@${var.zone}",
    "webmaster@${var.zone}",
    "postmaster@${var.zone}",
    "hostmaster@${var.zone}",
    "noreply@${var.zone}",
  ]

  enabled      = true
  scan_enabled = true

  s3_action {
    bucket_name = "${aws_s3_bucket.admin_inbox.id}"
    position    = 1
  }

  # lambda_action {
  #   function_arn = "arn:aws:lambda:us-east-1:${var.account_number}:function:ses-forwarder-${var.env}-handler"
  #   position     = 2
  # }
}
