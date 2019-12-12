resource "aws_codebuild_project" "codebuild" {
  name          = "${var.project}-codebuild-cicd-${var.name}-${var.customer}"
  description   = "CI/CD CodeBuild for ${var.project}"
  build_timeout = "30"
  service_role  = data.terraform_remote_state.iam.outputs.codebuild_cicd_iam_role_arn
  count         = var.create

  source {
    type            = var.source_type
    location        = var.source_location
    git_clone_depth = 1

    buildspec = var.source_type == "NO_SOURCE" ? var.buildspec_yaml : ".cloud/jenkins/buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    image                       = var.environment_image == "m6web-base" ? var.environment_m6web_base_image : "aws/codebuild/standard:2.0"
    image_pull_credentials_type = var.environment_image == "m6web-base" ? "SERVICE_ROLE" : "CODEBUILD"

    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project
      type  = "PLAINTEXT"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "codebuild-cicd"
      stream_name = "${var.project}-${var.name}"
    }
  }

  vpc_config {
    vpc_id = data.terraform_remote_state.network.outputs.vpc-id

    subnets = [
      data.terraform_remote_state.network.outputs.subnet-eu-west-3a-priv,
      data.terraform_remote_state.network.outputs.subnet-eu-west-3b-priv,
      data.terraform_remote_state.network.outputs.subnet-eu-west-3c-priv,
    ]

    security_group_ids = [
      data.terraform_remote_state.security_group.outputs.allow_all_outbound_id,
    ]
  }

  artifacts {
    type                   = "S3"
    encryption_disabled    = true
    location               = data.terraform_remote_state.s3.outputs.codebuild_cicd_s3_bucket
    name                   = "logs"
    path                   = "${var.project}/artifacts"
    override_artifact_name = true
  }

  secondary_artifacts {
    type                   = "S3"
    encryption_disabled    = true
    location               = data.terraform_remote_state.s3.outputs.codebuild_cicd_s3_bucket
    name                   = "screenshots"
    path                   = "${var.project}/artifacts"
    override_artifact_name = true
    artifact_identifier    = "screenshots"
  }

  cache {
    type  = "LOCAL"
    modes = var.source_type == "NO_SOURCE" ? ["LOCAL_DOCKER_LAYER_CACHE"] : ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  tags = {
    project  = var.project
    team     = var.team
    customer = var.customer
    tenant   = var.tenant
  }
}
