data "aws_iam_policy_document" "packer_policy" {
  statement {
    effect = "Allow"

    actions = [
      "route53:GetChange",
      "route53:ListHostedZonesByName",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${aws_route53_zone.relifeted_info.zone_id}",
      "arn:aws:route53:::hostedzone/${aws_route53_zone.relifeted_info.zone_id}",
    ]
  }
}

module "packer" {
  source = "../modules/aws_ec2_role"

  name   = "packer"
  policy = "${data.aws_iam_policy_document.packer_policy.json}"
}
