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
