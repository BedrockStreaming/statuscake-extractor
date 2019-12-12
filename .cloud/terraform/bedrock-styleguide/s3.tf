resource "aws_s3_bucket" "s3-styleguide" {
  bucket = "${var.project}-${var.customer}-styleguide-assets-${terraform.workspace}"
  count  = var.create_bucket ? 1 : 0
  acl    = "private"

  tags = {
    project  = var.project
    team     = var.team
    customer = var.customer
    tenant   = var.tenant
  }

  logging {
    target_bucket = data.terraform_remote_state.application_log.outputs.bucket_name
    target_prefix = "s3/${var.project}-${terraform.workspace}-${var.customer}-styleguide/"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "tmp"
    prefix  = "/"
    enabled = true

    expiration {
      days = 90
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "static_cdn_origin_access_identity" {
  count   = var.create_bucket ? 1 : 0
  comment = "${var.project}-${var.customer}-${var.tenant}-cloudfront"
}

resource "aws_s3_bucket_policy" "static_policy" {
  count  = var.create_bucket ? 1 : 0
  bucket = aws_s3_bucket.s3-styleguide[0].id
  policy = data.aws_iam_policy_document.s3_policy[0].json
}

data "aws_iam_policy_document" "s3_policy" {
  count = var.create_bucket ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3-styleguide[0].arn}/*",
    ]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.static_cdn_origin_access_identity[0].iam_arn]
      type        = "AWS"
    }
  }
}

data "terraform_remote_state" "application_log" {
  backend = "s3"

  config = {
    bucket               = "6cloud-tfstates"
    key                  = "${terraform.workspace}/github.m6web.fr/sysadmin/terraform/30_applications/logs.tfstate"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region               = var.region
    profile              = "6cloud-services"
    workspace_key_prefix = ""
  }
}
