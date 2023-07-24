# ------------------
# General
# ------------------
variable "location" {
  type        = string
  description = "Location (Azure Region) that will be used for resources"
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
  description = "Any tags that should be present on the all the resources"
}

variable "resource_group_network" {
  type        = any
  description = "AKS Network Resource Group"
}

variable "snet_aks" {
  type        = any
  description = "AKS Subnet Object for blue"
}
