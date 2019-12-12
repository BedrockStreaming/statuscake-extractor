data "terraform_remote_state" "application_log" {
  backend = "s3"

  config = {
    bucket               = "6cloud-tfstates"
    key                  = "${terraform.workspace}/github.m6web.fr/sysadmin/terraform/30_applications/logs.tfstate"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region               = var.region
    profile              = "6cloud-services"
    workspace_key_prefix = ""
  }
}

data "terraform_remote_state" "fastly_user_log" {
  backend = "s3"

  config = {
    bucket     = "6cloud-tfstates"
    key        = "github.m6web.fr/sysadmin/terraform/00_iam/users/${terraform.workspace}.tfstate"
    encrypt    = true
    kms_key_id = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region     = "eu-west-3"
    profile    = "6cloud-services"
  }
}

data "terraform_remote_state" "security_acl" {
  backend = "s3"

  config = {
    bucket               = "6cloud-tfstates"
    key                  = "${terraform.workspace}/github.m6web.fr/sysadmin/terraform/10_security/acl.tfstate"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region               = "${var.region}"
    profile              = "6cloud-services"
    workspace_key_prefix = ""
  }
}

data "terraform_remote_state" "certificates" {
  backend = "s3"

  config = {
    bucket               = "6cloud-tfstates"
    key                  = "github.m6web.fr/sysadmin/terraform/41_certificates.tfstate"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-west-3:908538848727:key/ae408c08-77b9-4670-8b68-7d7941208ff8"
    region               = "${var.region}"
    profile              = "6cloud-services"
    workspace_key_prefix = ""
  }
}
