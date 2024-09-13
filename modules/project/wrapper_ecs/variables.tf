/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

variable "project" {
  type = string
}

/*----------------------------------------------------------------------*/
/* ECS | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "ecs_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "ecs_defaults" {
  type        = any
  description = ""
  default     = {}
}