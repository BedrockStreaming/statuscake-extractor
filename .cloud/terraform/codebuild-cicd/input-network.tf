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
