/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* VPC | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "vpc_parameters" {
  type        = any
  description = "vpc parameteres to configure vpc module"
  default     = {}
}

variable "vpc_defaults" {
  type        = any
  description = "vpc defaults parameteres to configure vpc module"
  default     = {}
}

/*----------------------------------------------------------------------*/
/* Route53 | Variable Definition                                        */
/*----------------------------------------------------------------------*/
variable "route53_parameters" {
  type        = any
  description = "route53 parameteres to configure route53 module"
  default     = {}
}

variable "route53_defaults" {
  type        = any
  description = "route53 defaults parameteres to configure route53 module"
  default     = {}
}