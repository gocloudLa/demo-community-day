/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* ACM | Variable Definition                                            */
/*----------------------------------------------------------------------*/
variable "acm_parameters" {
  type        = any
  description = "acm parameteres to configure acm module"
  default     = {}
}

variable "acm_defaults" {
  type        = any
  description = "acm parameteres to configure acm module"
  default     = {}
}
