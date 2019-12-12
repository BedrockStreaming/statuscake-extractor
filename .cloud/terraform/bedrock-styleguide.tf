module "bedrock_styleguide_bedrock" {
  source = "./bedrock-styleguide/"

  customer          = "bedrock"
  tenant            = "rtlmutu"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "bedrock", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_bedrock" {
  value = module.bedrock_styleguide_bedrock.domain_name
}

output "cloudfront_styleguide_bedrock_zone_id" {
  value = module.bedrock_styleguide_bedrock.zone_id
}

module "bedrock_styleguide_m6web" {
  source = "./bedrock-styleguide/"

  customer          = "m6web"
  tenant            = "rtlmutu"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "m6web", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_m6web" {
  value = module.bedrock_styleguide_m6web.domain_name
}

output "cloudfront_styleguide_m6web_zone_id" {
  value = module.bedrock_styleguide_m6web.zone_id
}

module "bedrock_styleguide_rtlhu" {
  source = "./bedrock-styleguide/"

  customer          = "rtlhu"
  tenant            = "rtlmutu"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "rtlhu", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_rtlhu" {
  value = module.bedrock_styleguide_rtlhu.domain_name
}

output "cloudfront_styleguide_rtlhu_zone_id" {
  value = module.bedrock_styleguide_rtlhu.zone_id
}

module "bedrock_styleguide_rtlhr" {
  source = "./bedrock-styleguide/"

  customer          = "rtlhr"
  tenant            = "rtlmutu"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "rtlhr", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_rtlhr" {
  value = module.bedrock_styleguide_rtlhr.domain_name
}

output "cloudfront_styleguide_rtlhr_zone_id" {
  value = module.bedrock_styleguide_rtlhr.zone_id
}

module "bedrock_styleguide_rtlbe" {
  source = "./bedrock-styleguide/"

  customer          = "rtlbe"
  tenant            = "rtlmutu"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "rtlbe", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_6cloud_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_rtlbe" {
  value = module.bedrock_styleguide_rtlbe.domain_name
}

output "cloudfront_styleguide_rtlbe_zone_id" {
  value = module.bedrock_styleguide_rtlbe.zone_id
}

module "bedrock_styleguide_salto" {
  source = "./bedrock-styleguide/"

  customer          = "salto"
  tenant            = "salto"
  create            = var.create_styleguide
  create_cloudfront = var.styleguide_cloudfront
  create_bucket     = var.styleguide_bucket
  create_roles      = var.styleguide_create_roles
  domain_name       = lookup(var.styleguide_domain, "salto", "")
  cdn_certificate   = data.terraform_remote_state.certificates.outputs.acm_certificates_salto_fr_us_east_1.staging
  web_acl_id        = data.terraform_remote_state.security_acl.outputs.waf_acl_rtlmutu_only_allow_partners_id
}

output "cloudfront_styleguide_salto" {
  value = module.bedrock_styleguide_salto.domain_name
}

output "cloudfront_styleguide_salto_zone_id" {
  value = module.bedrock_styleguide_salto.zone_id
}
