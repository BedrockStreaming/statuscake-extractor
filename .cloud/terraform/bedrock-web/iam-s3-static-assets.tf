resource "aws_iam_user" "user" {
  name  = "${var.project}-user-${var.customer}"
  count = var.create_iam_static_assets

  tags = {
    project = var.project
    team    = var.team
  }
}

resource "aws_iam_access_key" "key" {
  user  = aws_iam_user.user[0].name
  count = var.create_iam_static_assets
}

resource "aws_iam_user_policy" "policy" {
  name  = "${var.project}-userPolicy-${var.customer}"
  user  = aws_iam_user.user[0].name
  count = var.create_iam_static_assets

  policy = data.aws_iam_policy_document.policy[0].json
}

data "aws_iam_policy_document" "policy" {
  count = var.create_iam_static_assets

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.s3-web-static-assets[0].arn,
    ]
  }
}

resource "aws_cloudfront_origin_access_identity" "static_cdn_origin_access_identity" {
  count   = var.create_iam_static_assets
  comment = "${var.project}-${var.customer}-${var.tenant}-cloudfront"
}

resource "aws_s3_bucket_policy" "static_policy" {
  count  = var.create_iam_static_assets
  bucket = aws_s3_bucket.s3-web-static-assets[0].id
  policy = data.aws_iam_policy_document.s3_policy[0].json
}

data "aws_iam_policy_document" "s3_policy" {
  count = var.create_iam_static_assets

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.s3-web-static-assets[0].arn}/*",
    ]

    principals {
      identifiers = [aws_cloudfront_origin_access_identity.static_cdn_origin_access_identity[0].iam_arn]
      type        = "AWS"
    }
  }
}

resource "aws_iam_role_policy_attachment" "push_to_s3_role-attach" {
  count      = var.create_iam_static_assets
  role       = module.codebuild_cicd_heavy.codebuid_info.name
  policy_arn = aws_iam_policy.push_to_s3[0].arn
}

resource "aws_iam_policy" "push_to_s3" {
  count  = var.create_iam_static_assets
  policy = data.aws_iam_policy_document.push_to_s3[0].json
}

data "aws_iam_policy_document" "push_to_s3" {
  count = var.create_iam_static_assets
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]

    resources = [
      "${aws_s3_bucket.s3-web-static-assets[0].arn}/*",
    ]
  }
}
