/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

# variable "metadata" {
#   type = any
# }

/*----------------------------------------------------------------------*/
/* VPC | Variable Definition                                            */
/*----------------------------------------------------------------------*/
variable "vpc_parameters" {
  type        = any
  description = "vpc parameteres"
  default     = {}
}

variable "vpc_defaults" {
  type        = any
  description = "vpc default parameteres"
  default     = {}
}