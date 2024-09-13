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
/* BUCKET | Variable Definition                                         */
/*----------------------------------------------------------------------*/

variable "bucket_parameters" {
  type        = any
  description = ""
  default     = {}
}

variable "bucket_defaults" {
  type        = any
  description = ""
  default     = {}
}