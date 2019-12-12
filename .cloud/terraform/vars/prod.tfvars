aws_profile = "6cloud-prod"

create_ecr            = 0
create_codebuild_cicd = 0
create_iam            = 1
create_s3             = 1
fastly_enabled        = 1
create_codebuild_role = 1
cloudfront_enabled    = true

fastly_origin = "vip-6play-ssl.6play.fr"
fastly_domain = "www.6play.fr"

origin = {
  "rtlmutu" : "k8s-rtlmutu-external-vh5xfv-793338316.eu-west-3.elb.amazonaws.com",
  "salto" : "k8s-salto-external-g8fico-1774831943.eu-west-3.elb.amazonaws.com"
}

domain_name = {
  "m6web" = "m6web-front.6cloud.fr",
  "rtlhu" = "rtlhu-front.6cloud.fr",
  "rtlbe" = "rtlbe-front.6cloud.fr",
  "rtlhr" = "rtlhr-front.6cloud.fr",
  "salto" = "salto-front.salto.fr"
}

cdn_token = "teid1deyoo2eiGh4Ozuapho2u"
