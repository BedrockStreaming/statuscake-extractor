resource "aws_s3_bucket" "s3-web-static-assets" {
  bucket = "${var.project}-${terraform.workspace}-${var.customer}-web-static-assets"
  count  = var.create_s3_static_assets
  acl    = "private"

  tags = {
    project  = var.project
    team     = var.team
    customer = var.customer
    tenant   = var.tenant
  }

  logging {
    target_bucket = data.terraform_remote_state.application_log.outputs.bucket_name
    target_prefix = "s3/${var.project}-${terraform.workspace}-${var.customer}/"
  }

  versioning {
    enabled = true
  }
}
