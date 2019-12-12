resource "aws_iam_role" "bedrock_web_codebuild_role" {
  count = var.create_role

  name                  = "${var.project}-codebuild-${var.name}-${var.customer}"
  path                  = "/service-role/codebuild/"
  force_detach_policies = true

  max_session_duration = 28800
  assume_role_policy   = data.aws_iam_policy_document.bedrock_web_codebuild_assume_role[0].json

  tags = {
    environment = terraform.workspace
    project     = var.project
    team        = var.team
    customer    = var.customer
    tenant      = var.tenant
  }
}

data "aws_iam_policy_document" "bedrock_web_codebuild_assume_role" {
  count = var.create_role

  statement {
    effect = "Allow"

    # on staging/prod, allow incoming assumerole from services
    dynamic "principals" {
      for_each = data.aws_iam_account_alias.current.account_alias == "6cloud-staging" || data.aws_iam_account_alias.current.account_alias == "6cloud-prod" ? var.create_role == 1 ? [true] : [] : []
      content {
        type        = "AWS"
        identifiers = [data.terraform_remote_state.iam.outputs.codebuild_cicd_iam_role_arn]
      }
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_account_alias" "current" {
}

output "codebuid_info" {
  value = aws_iam_role.bedrock_web_codebuild_role[0]
}
