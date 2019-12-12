aws_profile = "6cloud-staging"

create_ecr            = 1
create_codebuild_cicd = 0
create_iam            = 1
create_s3             = 1
fastly_enabled        = 0
create_codebuild_role = 1
cloudfront_enabled    = true

fastly_origin = "pp-cache6-ssl.m6web.fr"
fastly_domain = "preprod.6play.fr"

origin = {
  "rtlmutu" : "k8s-rtlmutu-external-umqu8j-584973776.eu-west-3.elb.amazonaws.com",
  "salto" : "k8s-salto-external-k2yuce-106390302.eu-west-3.elb.amazonaws.com"
}

styleguide_create_roles = true
styleguide_cloudfront   = true
styleguide_bucket       = true

domain_name = {
  "m6web" = "m6web-front.staging.6cloud.fr",
  "rtlhu" = "rtlhu-front.staging.6cloud.fr",
  "rtlbe" = "rtlbe-front.staging.6cloud.fr",
  "rtlhr" = "rtlhr-front.staging.6cloud.fr",
  "salto" = "salto-front.staging.salto.fr"
}

styleguide_domain = {
  "bedrock" = "bedrock-styleguide.staging.6cloud.fr",
  "m6web"   = "m6web-styleguide.staging.6cloud.fr",
  "rtlhu"   = "rtlhu-styleguide.staging.6cloud.fr",
  "rtlbe"   = "rtlbe-styleguide.staging.6cloud.fr",
  "rtlhr"   = "rtlhr-styleguide.staging.6cloud.fr",
  "salto"   = "salto-styleguide.staging.salto.fr"
}

cdn_token = "etai2weejahy4XitodieVa4ai"
