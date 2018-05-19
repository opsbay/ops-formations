output "aws_iam_instance_profile" {
  value = {
    profile.arn  = "${aws_iam_instance_profile.profile.arn}"
    profile.name = "${aws_iam_instance_profile.profile.name}"
  }
}

output "aws_iam_role" {
  value = {
    role.id = "${aws_iam_role.role.id}"
  }
}
