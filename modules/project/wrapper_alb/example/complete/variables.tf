/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

# variable "metadata" {
#   type = any
# }

# variable "project" {
#   type = string
# }

/*----------------------------------------------------------------------*/
/* ALB | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "alb_parameters" {
  description = "Map of default values which will be used for each ALB."
  type        = any
  default     = {}
}

variable "alb_defaults" {
  description = "Maps of ALB to create a wrapper from. Values are passed through to the module."
  type        = any
  default     = {}
}