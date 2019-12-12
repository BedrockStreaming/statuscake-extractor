# TODO dynamiser le profile pour correspondre à l'environnement
provider "aws" {
  region  = "us-east-1"
  alias   = "certificate"
  profile = "6cloud-staging"
  version = "~> 2.21"
}

resource "aws_cloudfront_distribution" "bedrock_cloudfront" {
  enabled = var.cloudfront_enabled
  comment = "bedrock-cdn-${terraform.workspace}-${var.customer}"
  count   = var.cloudfront_enabled ? 1 : 0

  aliases     = [var.domain_name]
  price_class = "PriceClass_100"

  web_acl_id          = var.web_acl_id
  wait_for_deployment = false
  is_ipv6_enabled     = true

  origin {
    domain_name = var.origin
    origin_id   = "KubernetesPod"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]

      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
    }
  }

  origin {
    domain_name = aws_s3_bucket.s3-web-static-assets[0].bucket_regional_domain_name
    origin_id   = "StaticS3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.static_cdn_origin_access_identity[0].cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id = "KubernetesPod"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD", "OPTIONS"]
    compress        = true

    min_ttl     = 0
    max_ttl     = 31536000
    default_ttl = 60

    forwarded_values {
      query_string = true

      headers = [
        # Allow to forward real client hostname to ELB
        "Host",
      ]

      cookies {
        forward           = "whitelist"
        whitelisted_names = ["zedEnabled", "autologin"]
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/assets/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "StaticS3"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "*.js"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "StaticS3"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "*.css"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "StaticS3"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/static-*.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "StaticS3"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
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

  custom_error_response {
    error_code            = 502
    error_caching_min_ttl = 120
    response_code         = 200
    response_page_path    = "/static-index.html"
  }

  custom_error_response {
    error_code            = 503
    error_caching_min_ttl = 120
    response_code         = 200
    response_page_path    = "/static-index.html"
  }

  custom_error_response {
    error_code            = 504
    error_caching_min_ttl = 120
    response_code         = 200
    response_page_path    = "/static-index.html"
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
