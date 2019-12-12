resource "aws_iam_role" "bedrock_styleguide_codebuild_role" {
  count = var.create_roles ? 1 : 0

  name                  = "${var.project}-codebuild-${var.customer}"
  path                  = "/service-role/codebuild/"
  force_detach_policies = true

  max_session_duration = 28800
  assume_role_policy   = data.aws_iam_policy_document.bedrock_styleguide_codebuild_assume_role[0].json

  tags = {
    environment = terraform.workspace
    project     = var.project
    team        = var.team
    customer    = var.customer
    tenant      = var.tenant
  }
}

data "aws_iam_policy_document" "bedrock_styleguide_codebuild_assume_role" {
  count = var.create_roles ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.iam.outputs.codebuild_cicd_iam_role_arn]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_account_alias" "current" {
}

resource "aws_iam_role_policy_attachment" "push_to_s3_role-attach" {
  count      = var.create_roles ? 1 : 0
  role       = aws_iam_role.bedrock_styleguide_codebuild_role[0].name
  policy_arn = aws_iam_policy.push_to_s3[0].arn
}

resource "aws_iam_policy" "push_to_s3" {
  count  = var.create_roles ? 1 : 0
  policy = data.aws_iam_policy_document.push_to_s3[0].json
}

data "aws_iam_policy_document" "push_to_s3" {
  count = var.create_roles ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.s3-styleguide[0].arn}/*",
    ]
  }
}
