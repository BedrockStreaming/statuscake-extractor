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
