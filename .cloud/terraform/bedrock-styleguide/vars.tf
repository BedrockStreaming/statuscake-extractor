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
  default     = "bedrock-styleguide"
}

variable "team" {
  type        = string
  description = "Team flag"
  default     = "cytron"
}

variable "create" {
  type        = bool
  description = "Should the styleguide be created"
  default     = false
}

variable "region" {
  type        = string
  description = "AWS Region to use"
  default     = "eu-west-3"
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

variable "cdn_certificate" {
  type        = string
  description = "Certificate for the cdn"
}

variable "create_roles" {
  type        = bool
  description = "should create code build assume role"
}

variable "create_cloudfront" {
  type        = bool
  description = "should create cloudfront"
}

variable "create_bucket" {
  type        = bool
  description = "should create bucket"
}
