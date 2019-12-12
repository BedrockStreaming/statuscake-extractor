resource "aws_codebuild_project" "codebuild" {
  name          = "${var.project}-codebuild-cicd-${var.customer}"
  description   = "CI/CD CodeBuild for ${var.project}"
  build_timeout = "30"
  service_role  = data.terraform_remote_state.iam.outputs.codebuild_cicd_iam_role_arn
  count         = var.create ? 1 : 0

  source {
    type            = "GITHUB_ENTERPRISE"
    location        = "https://github.m6web.fr/m6web/site-6play-v4"
    git_clone_depth = 1

    buildspec = ".cloud/jenkins/buildspec/styleguide/buildspec.yml"
  }

  environment {
    compute_type = "BUILD_GENERAL1_MEDIUM"

    image                       = "aws/codebuild/standard:2.0"
    image_pull_credentials_type = "CODEBUILD"

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
      stream_name = var.project
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
    modes = ["LOCAL_SOURCE_CACHE"]
  }

  tags = {
    project  = var.project
    team     = var.team
    customer = var.customer
    tenant   = var.tenant
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket     = "6cloud-tfstates"
    key        = "services/github.m6web.fr/sysadmin/terraform/30_applications/codebuild-cicd.tfstate"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region     = "eu-west-3"
    profile    = "6cloud-services"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket     = "6cloud-tfstates"
    key        = "${terraform.workspace}/github.m6web.fr/sysadmin/terraform/00_network.tfstate"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region     = "eu-west-3"
    profile    = "6cloud-services"
  }
}

data "terraform_remote_state" "security_group" {
  backend = "s3"

  config = {
    bucket     = "6cloud-tfstates"
    key        = "${terraform.workspace}/github.m6web.fr/sysadmin/terraform/10_security/security_group.tfstate"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region     = "eu-west-3"
    profile    = "6cloud-services"
  }
}

data "terraform_remote_state" "s3" {
  backend = "s3"

  config = {
    bucket     = "6cloud-tfstates"
    key        = "services/github.m6web.fr/sysadmin/terraform/30_applications/codebuild-cicd.tfstate"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region     = "eu-west-3"
    profile    = "6cloud-services"
  }
}
