module "wrapper_alb" {
  source = "../../"

  metadata = local.metadata
  project  = local.project

  alb_parameters = {
    "ExExternal" = {
      subnets  = data.aws_subnets.public.ids
      internal = false
      http_tcp_listeners = [
        {
          port        = 80
          protocol    = "HTTP"
          action_type = "redirect"
          redirect = {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
            host        = "#{host}"
            path        = "/#{path}"
            query       = "#{query}"
          }
        }
      ]
      https_listeners = [
        {
          port            = 443
          protocol        = "HTTPS"
          certificate_arn = data.aws_acm_certificate.this.arn
          action_type     = "fixed-response"
          fixed_response = {
            content_type = "text/plain"
            message_body = "Fixed message"
            status_code  = "200"
          }
        }
      ]
      ingress_with_cidr_blocks = [
        {
          rule        = "http-80-tcp"
          cidr_blocks = "0.0.0.0/0"
          description = "Enable all access"
        },
        {
          rule        = "https-443-tcp"
          cidr_blocks = "0.0.0.0/0"
          description = "Enable all access"
        }
      ]
      dns_records = {
        "" = {
          zone_name    = "${local.zone_public}"
          private_zone = false
        }
      }
    }
  }

  alb_defaults = var.alb_defaults
}