provider "fastly" {
  version = "v0.8.1"
}

resource "fastly_service_v1" "sixplay" {
  count       = var.fastly_enabled
  name        = var.fastly_domain
  activate    = true
  default_ttl = 10

  domain {
    name    = var.fastly_domain
    comment = "Fastly service for 6play"
  }

  backend {
    name              = "addr ${var.fastly_origin}"
    address           = var.fastly_origin
    port              = 443
    use_ssl           = true
    ssl_cert_hostname = var.fastly_domain
    shield            = "cdg-par-fr"
    auto_loadbalance  = false
    ssl_sni_hostname  = var.fastly_domain
    connect_timeout   = 5000
  }

  gzip {
    name          = "Gzip compression"
    extensions    = ["css", "js", "html", "eot", "ico", "otf", "ttf", "json", "svg"]
    content_types = ["text/html", "application/x-javascript", "text/css", "application/javascript", "text/javascript", "application/json", "application/vnd.ms-fontobject", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/xml", "font/eot", "font/opentype", "font/otf", "image/svg+xml", "image/vnd.microsoft.icon", "text/plain", "text/xml"]
  }

  s3logging {
    name           = "s3_6play_logs_WO"
    bucket_name    = data.terraform_remote_state.application_log.outputs.bucket_name
    domain         = "s3-eu-west-1.amazonaws.com"
    s3_access_key  = data.terraform_remote_state.fastly_user_log.outputs.fastly_logs_access_key_id
    s3_secret_key  = data.terraform_remote_state.fastly_user_log.outputs.fastly_logs_access_key_secret
    path           = "fastly/${var.fastly_domain}/"
    format         = "%h %l %u %t \"%r\" %>s %b %%{User-Agent}i %%{Referer}i"
    format_version = "2"
  }

  request_setting {
    name          = "Global settings"
    default_host  = var.fastly_domain
    max_stale_age = "43200"
    force_ssl     = true
  }

  request_setting {
    name              = "Set Hash from Cookie"
    request_condition = "If Has zedEnabled cookie"
    hash_keys         = "req.url, req.http.host, req.http.X-zedEnabled"
    force_ssl         = false
  }

  header {
    name        = "Enable HSTS"
    destination = "http.Strict-Transport-Security"
    source      = "\"max-age=31536000\""
    type        = "response"
    action      = "set"
  }

  header {
    name        = "Default value for Cookie zedEnabled=false"
    destination = "http.X-zedEnabled"
    source      = "\"false\""
    type        = "request"
    priority    = "10"
    action      = "set"
  }

  header {
    name        = "Send X-Origin-CDN token header to origin"
    destination = "http.X-Origin-CDN"
    source      = "\"${var.cdn_token}\""
    type        = "request"
    priority    = "10"
    action      = "set"
  }

  header {
    name              = "Set value for zedEnabled from Cookie"
    destination       = "http.X-zedEnabled"
    source            = "req.http.cookie:zedEnabled"
    type              = "request"
    priority          = "20"
    request_condition = "If Has zedEnabled cookie"
    action            = "set"
  }

  condition {
    type      = "REQUEST"
    name      = "If Has zedEnabled cookie"
    statement = "req.http.cookie:zedEnabled"
    priority  = "10"
  }

  snippet {
    name    = "ip-restriction-recv"
    type    = "recv"
    content = file("files/ip_restriction_recv_${terraform.workspace}.vcl")
  }

  snippet {
    name    = "custom-403-error"
    type    = "error"
    content = file("files/custom_403_error.vcl")
  }
}
