## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_static-site"></a> [static-site](#module\_static-site) | ../aws/terraform-aws-static-site | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.static_site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metadata"></a> [metadata](#input\_metadata) | n/a | `any` | n/a | yes |
| <a name="input_static_site_defaults"></a> [static\_site\_defaults](#input\_static\_site\_defaults) | Map of default values which will be used for each item. | `any` | `{}` | no |
| <a name="input_static_site_parameters"></a> [static\_site\_parameters](#input\_static\_site\_parameters) | n/a | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_static-site-output"></a> [static-site-output](#output\_static-site-output) | n/a |
