variable "team" {
  type        = string
  description = "Maintainer team"
}

variable "project" {
  type        = string
  description = "Name of the current project"
}

variable "name" {
  type        = string
  description = "Sub-name of the CodeBuild project ('big', 'small', 'lightweight'…)"
}

variable "create" {
  type        = number
  description = "Create this CodeBuild project?"
}

variable "create_role" {
  type        = number
  description = "Create this CodeBuild roles"
}

variable "environment_image" {
  type        = string
  description = "Which Docker CodeBuild image must be used for the build? A custom one on ECR? Or AWS standard one? Accepted value: ['m6web-base', 'aws']"
}

variable "environment_m6web_base_image" {
  type        = string
  description = "Which Docker image on ECR?"
  default     = "908538848727.dkr.ecr.eu-west-3.amazonaws.com/codebuild-m6web-base:20191015143554-origin-master"
}

variable "source_type" {
  type        = string
  description = "See aws_codebuild_project:source.type"
}

variable "source_location" {
  type        = string
  default     = ""
  description = "See aws_codebuild_project:source.location"
}

variable "buildspec_yaml" {
  type        = string
  description = "If source_type is set to 'NO_SOURCE', this will be used as buildspec. Must be a valid buildspec YAML string (not a path to a file)."
  default     = <<EOF
version: 0.2

phases:
  install:
    runtime-versions:
      docker: 18
  pre_build:
    commands:
      - $(aws ecr get-login --no-include-email --region $AWS_REGION --registry-ids $AWS_ACCOUNT)
  build:
    commands:
      - "docker run --rm $IMAGE_NAME sh -c \"$(echo $CMD | base64 --decode)\""
EOF

}

variable "customer" {
  type        = "string"
  description = "Current customer used"
}

variable "tenant" {
  type        = "string"
  description = "Current tenant used"
}
