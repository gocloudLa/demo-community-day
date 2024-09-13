/*----------------------------------------------------------------------*/
/* GitLab | Variable Definition                                         */
/*----------------------------------------------------------------------*/

variable "gitlab_registration_token" {
  description = "token to registrarion gitlab-runner"
  sensitive   = true
  default     = ""
}

/*----------------------------------------------------------------------*/
/* Notifications | Variable Definition                                  */
/*----------------------------------------------------------------------*/
variable "notifications_discord_webhook_url" {
  description = "discord webhook url for notifications"
  sensitive   = true
  default     = ""
}

/*----------------------------------------------------------------------*/
/* Alarms | Variable Definition                                         */
/*----------------------------------------------------------------------*/
variable "alarms_discord_webhook_url" {
  description = "discord webhook url for alarms"
  sensitive   = true
  default     = ""
}