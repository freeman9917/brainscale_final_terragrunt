locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))


  # Extract the variables we need for easy access
  region        = local.region_vars.locals.region

  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
}




# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
     mock_outputs = {
       vpc_id = "sample-vpc_id"
       private_subnets = ["sample_private_subnet1_id", "sample_private_subnet2_id"]
     }   
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  private_subnets            = dependency.vpc.outputs["private_subnets"]
  env_prefix             = "${local.env}"        
}

