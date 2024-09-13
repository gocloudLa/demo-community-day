/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

# variable "metadata" {
#   type = any
# }

/*----------------------------------------------------------------------*/
/* Route53 | Variable Definition                                        */
/*----------------------------------------------------------------------*/
variable "route53_parameters" {
  type        = any
  description = "Route53 parameteres to declare hosted zone"
  default     = {}
}

variable "route53_defaults" {
  type        = any
  description = "Route53 default parameteres to declare hosted zone"
  default     = {}
}