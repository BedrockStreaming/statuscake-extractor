aws_profile = "6cloud-sandbox"

create_ecr            = 0
create_codebuild_cicd = 1
create_iam            = 0
create_s3             = 0

fastly_enabled = false

origin = ""

domain_name = ""

cdn_token = ""

ecr_write_arns = [
  "arn:aws:iam::848114327112:role/adminsys",
  "arn:aws:iam::848114327112:role/techlead",
  "arn:aws:iam::848114327112:role/tech",
  "arn:aws:iam::848114327112:role/service-role/codebuild-cicd",
  "arn:aws:iam::908538848727:role/service-role/codebuild-cicd",
]
