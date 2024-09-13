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
/* ECS | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "ecs_defaults" {
  description = "Map of default values which will be used for each rds database."
  type        = any
  default     = {}
}

variable "ecs_parameters" {
  description = "Maps of rds databases to create a wrapper from. Values are passed through to the module."
  type        = any
  default     = {}
}