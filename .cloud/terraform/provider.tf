provider "aws" {
  region  = var.region
  profile = var.aws_profile
  version = "~> 2.21"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "certificate"
  profile = var.aws_profile
  version = "~> 2.21"
}

provider "aws" {
  region  = var.region
  profile = "6cloud-services"
  alias   = "services"
  version = "~> 2.21"
}

