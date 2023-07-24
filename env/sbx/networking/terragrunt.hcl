locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "${get_path_to_repo_root()}/modules/networking"
}

include {
  path = find_in_parent_folders()
}

inputs = merge(
  local.env_vars.locals,
  {
    tags                       = { "managedBy" = "terraform", "environment" = local.env_vars.locals.environment, "state" = basename(get_original_terragrunt_dir()), "color" = "blue" }
  }
)
