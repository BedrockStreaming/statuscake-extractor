variable "customer" {
  type        = string
  description = "Current customer used"
}

variable "tenant" {
  type        = string
  description = "Current tenant used"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "bedrock-web"
}

variable "team" {
  type        = string
  description = "Team flag"
  default     = "cytron"
}

variable "region" {
  type        = string
  description = "AWS Region to use"
  default     = "eu-west-3"
}

variable "create_s3_static_assets" {
  type        = number
  description = "How many static assets bucket should be created"
  default     = 0
}

variable "create_iam_static_assets" {
  type        = number
  description = "How many static assets iam should be created"
  default     = 0
}

variable "ecr_write_arns" {
  type        = list(string)
  description = "ARNs that will able to write to ECR"

  default = [
    "arn:aws:iam::908538848727:role/adminsys",
    "arn:aws:iam::908538848727:role/jenkins-ecr",
    "arn:aws:iam::908538848727:role/service-role/codebuild-cicd",
  ]
}

variable "ecr_read_arns" {
  type        = list(string)
  description = "ARNs that will able to pull from ECR"

  default = [
    "arn:aws:iam::283504130005:root",
    "arn:aws:iam::311275790335:root",
    "arn:aws:iam::072369617205:root",
    "arn:aws:iam::908538848727:root",
    "arn:aws:iam::848114327112:root",
  ]
  // Everyone @ 6cloud-services
}

variable "create_ecr" {
  description = "Create ECR repositories?"
}

variable "fastly_enabled" {
  description = "Create Fastly repositories?"
  type        = number
  default     = 0
}

variable "cloudfront_enabled" {
  description = "Create Cloudfront repositories?"
  type        = bool
  default     = false
}

variable "web_acl_id" {
  type        = "string"
  description = "If set, the id of the Web ACL used to filter access"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "Domain for the service"
}

variable "origin" {
  type        = string
  description = "Origin for the service"
}

variable "cdn_token" {
  type        = string
  description = "Cdn token for fastly"
}

variable "cdn_certificate" {
  type        = string
  description = "Certificate for the cdn"
}

variable "create_codebuild_cicd" {
  type        = number
  description = "Create this CodeBuild project?"
}

variable "create_codebuild_role" {
  description = "Create CI/CD CodeBuild project IAM role"
  type        = number
  default     = 0
}

variable "source_location" {
  type        = string
  default     = "https://github.m6web.fr/m6web/site-6play-v4"
  description = "See aws_codebuild_project:source.location"
}
