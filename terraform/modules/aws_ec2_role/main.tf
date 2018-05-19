resource "aws_iam_role_policy" "policy" {
  count = "${var.policy == "" ? 0 : 1}"
  name  = "${var.name}"
  role  = "${aws_iam_role.role.id}"

  policy = "${var.policy}"
}

data "aws_iam_policy_document" "AssumeRole" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "${var.name}"

  assume_role_policy = "${data.aws_iam_policy_document.AssumeRole.json}"
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.name}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccess" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforSSM" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "CloudWatchLogsFullAccess" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccess" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSXrayWriteOnlyAccess" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonInspectorReadOnlyAccess" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonInspectorReadOnlyAccess"
}
