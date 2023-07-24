# ------------------
# General
# ------------------
variable "location" {
  type        = string
  description = "Location/Region that will be used for resources"
}

variable "prefix" {
  type        = string
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "environment" {
  type        = string
  description = "The environment name that will be used for tagging"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Any tags that should be present on the resources"
}
