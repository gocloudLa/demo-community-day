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
  description = "VPC parameteres to configure VPC module"
  default     = {}
}

variable "vpc_defaults" {
  type        = any
  description = "VPC defaults parameteres to configure VPC module"
  default     = {}
}
