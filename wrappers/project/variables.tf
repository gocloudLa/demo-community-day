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
/* ALB | Variable Definition                                            */
/*----------------------------------------------------------------------*/

variable "alb_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "alb_defaults" {
  description = "Map of default values which will be used for each item."
  type        = any
  default     = {}
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

/*----------------------------------------------------------------------*/
/* BUCKET | Variable Definition                                         */
/*----------------------------------------------------------------------*/

variable "bucket_defaults" {
  description = "Map of defaults values which will be used for each bucket."
  type        = any
  default     = {}
}

variable "bucket_parameters" {
  description = "Map of values which will be used for each bucket."
  type        = any
  default     = {}
}