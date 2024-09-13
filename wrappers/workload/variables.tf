/*----------------------------------------------------------------------*/
/* Common |                                                             */
/*----------------------------------------------------------------------*/

variable "metadata" {
  type = any
}

/*----------------------------------------------------------------------*/
/* Static Site | Variable Definition                                    */
/*----------------------------------------------------------------------*/

variable "static_site_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "static_site_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}

/*----------------------------------------------------------------------*/
/* ECS Service | Variable Definition                                    */
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

/*----------------------------------------------------------------------*/
/* Lambda | Variable Definition                                         */
/*----------------------------------------------------------------------*/

variable "lambda_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "lambda_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
}