data "aws_iam_role" "ControlPlane" {
  name = "${var.iam_role_prefix}-ControlPlane-Role"
}

data "aws_iam_role" "Installer" {
  name = "${var.iam_role_prefix}-Installer-Role"
}

data "aws_iam_role" "Support" {
  name = "${var.iam_role_prefix}-Support-Role"
}

data "aws_iam_role" "Worker" {
  name = "${var.iam_role_prefix}-Worker-Role"
}


output "ControlPlane-Role" {
  value = data.aws_iam_role.ControlPlane.arn
}

output "Installer-Role" {
  value = data.aws_iam_role.Installer.arn
}

output "Support-Role" {
  value = data.aws_iam_role.Support.arn
}

output "Worker-Role" {
  value = data.aws_iam_role.Worker.arn
}

