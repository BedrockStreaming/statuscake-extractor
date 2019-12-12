variable "aws_profile" {
  type        = string
  description = "AWS profile to use"
}

variable "region" {
  type        = string
  description = "AWS Region to use"
  default     = "eu-west-3"
}

variable "team" {
  type        = string
  description = "Maintainer team"
  default     = "cytron"
}

variable "project" {
  type        = string
  description = "Name of the current project"
  default     = "site-6play-v4"
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
  type        = number
  description = "Create ECR repositories?"

  default = 0
}

#######
## Fastly
#######
variable "fastly_enabled" {
  type        = string
  description = "Is fastly enabled ?"

  default = false
}

variable "fastly_domain" {
  type        = string
  description = "Name to serve as entry point"
  default     = ""
}

variable "fastly_origin" {
  type        = string
  description = "Backend address"
  default     = ""
}

variable "domain_name" {
  type        = map(string)
  description = "Name to serve as entry point"
  default     = {}
}

variable "origin" {
  type        = map(string)
  description = "Backend address"
  default     = {}
}

variable "cdn_token" {
  type        = string
  description = "Security token between cdn and app"

  default = "toset"
}

# CI/CD

variable "create_codebuild_cicd" {
  description = "Create CI/CD CodeBuild project?"
}

# CI/CD

variable "create_codebuild_role" {
  description = "Create CI/CD CodeBuild project IAM role"
  type        = number
  default     = 0
}

# IAM

variable "create_iam" {
  description = "Create IAM user and key and permissions?"
}

# S3

variable "create_s3" {
  description = "Create S3 bucket?"
}

variable "cloudfront_enabled" {
  description = "Create Cloudfront repositories?"
  type        = bool
  default     = false
}

variable "create_styleguide" {
  description = "Should we create styleguide"
  type        = bool
  default     = false
}

variable "styleguide_domain" {
  description = "domain for the styleguide by customer"
  default     = {}
}

variable "styleguide_create_roles" {
  default     = false
  description = "should create assume role and role to push on bucket"
}

variable "styleguide_cloudfront" {
  default     = false
  description = "should create cloudfront distribution"
}

variable "styleguide_bucket" {
  default     = false
  description = "should create buck distribution"
}
