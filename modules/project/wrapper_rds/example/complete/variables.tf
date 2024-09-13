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
/* RDS | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "rds_defaults" {
  description = "Map of default values which will be used for each rds database."
  type        = any
  default     = {}
}

variable "rds_parameters" {
  description = "Maps of rds databases to create a wrapper from. Values are passed through to the module."
  type        = any
  default     = {}
}