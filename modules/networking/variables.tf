## --------------------
## General
## --------------------

variable "prefix" {
  type        = string
  description = "Prefix to include in all resource names"
}

variable "location" {
  type        = string
  description = "Location/region where all the resources will be deployed"
}

variable "environment" {
  type        = string
  description = "Environment to include in all resource names"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags that should be present on the vnet"
}
