resource "aws_cloudfront_distribution" "bedrock_cloudfront" {
  enabled = var.create_cloudfront
  comment = "bedrock-cdn-${terraform.workspace}-${var.customer}"
  count   = var.create_cloudfront ? 1 : 0

  aliases     = [var.domain_name]
  price_class = "PriceClass_100"

  web_acl_id          = var.web_acl_id
  wait_for_deployment = false
  is_ipv6_enabled     = true

  origin {
    domain_name = aws_s3_bucket.s3-styleguide[0].bucket_regional_domain_name
    origin_id   = "StaticS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_cdn_origin_access_identity[0].cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id = "StaticS3"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    min_ttl     = 0
    max_ttl     = 31536000
    default_ttl = 600

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    path_pattern           = "*.html"
    target_origin_id       = "StaticS3"
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    max_ttl     = 60
    default_ttl = 60

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cdn_certificate
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  logging_config {
    include_cookies = false
    bucket          = data.terraform_remote_state.application_log.outputs.bucket_domain_name
    prefix          = "cloudfront/bedrock-web-${var.customer}"
  }

  tags = {
    project  = var.project
    team     = var.team
    customer = var.customer
    tenant   = var.tenant
  }
}

output "domain_name" {
  value = "${aws_cloudfront_distribution.bedrock_cloudfront.*.domain_name}"
}

output "zone_id" {
  value = "${aws_cloudfront_distribution.bedrock_cloudfront.*.hosted_zone_id}"
}
