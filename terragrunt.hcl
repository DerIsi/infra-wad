locals {
  env_vars        = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  module_name     = basename(get_original_terragrunt_dir())
  subscription_id = local.env_vars.locals.subscription_id
}

terraform {
  extra_arguments "force_subscription" {
    commands = [
      "init",
      "apply",
      "destroy",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]
    env_vars = {
      ARM_SUBSCRIPTION_ID = local.env_vars.locals.subscription_id
      ARM_TENANT_ID       = ""
    }
  }
  before_hook "set-az-subscription" {
    commands = [
      "init",
      "apply",
      "destroy",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]
    execute = ["bash", "-c", "[[ -n $CI ]] || az account set --subscription ${local.env_vars.locals.subscription_id}"]
  }
}

generate "provider" {
  path      = "tg_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-${local.env_vars.locals.prefix}-${local.env_vars.locals.environment}-state"
    storage_account_name = "st${local.env_vars.locals.prefix}${local.env_vars.locals.environment}state"
    container_name       = "stc${local.env_vars.locals.prefix}${local.env_vars.locals.environment}state"
    key                  = "${local.module_name}.terraform.tfstate"
    snapshot             = true
  }
  generate = {
    path      = "tg_backend.tf"
    if_exists = "overwrite"
  }
}

inputs = merge(
  local.env_vars,
)
