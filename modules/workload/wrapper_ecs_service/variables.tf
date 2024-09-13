/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* Static Site | Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "ecs_service_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "ecs_service_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}