# locals {
#   # Automatically load environment-level variables
#   environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
#   region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
#   account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

#   # Extract out common variables for reuse
#   env    = local.environment_vars.locals.environment
#   owner  = local.account_vars.locals.owner
#   region = local.region_vars.locals.region
# }

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules/helm"
}

dependency "eks" {
  config_path = "../eks"
       mock_outputs = {
       cluster_endpoint = "sample-cluster_endpoint"
       cluster_certificate_authority_data = "YnJhaW5zY2FsZQ=="
       cluster_name = "sample-cluster_name"
       root_app_path = "./root_chart_prod"
     }
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above

inputs = {
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_certificate_authority_data            = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_name             = dependency.eks.outputs.cluster_name
  root_app_path = "./root_chart_prod"
}

