# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract the variables we need for easy access
  region        = local.region_vars.locals.region
  account_name  = local.account_vars.locals.account_name

}

#Configure Terragrunt to automatically store tfstate files in an S3 bucket
# remote_state {
#   backend = "s3"
#   config = {
#     encrypt        = true
#     bucket         = "${local.account_name}-${local.region}-tr-tf-state"
#     key            = "${path_relative_to_include()}/terraform.tfstate"
#     region         = local.region
#     dynamodb_table = "vahe-lock-table"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }



# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"

  # Only these AWS Account IDs may be operated on by this template
}

EOF
}




# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
# inputs = merge(
  # local.account_vars.locals,
  # local.region_vars.locals,
  # local.environment_vars.locals,
# )