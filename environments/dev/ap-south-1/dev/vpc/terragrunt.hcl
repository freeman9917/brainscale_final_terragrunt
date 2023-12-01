locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))


  # Extract the variables we need for easy access
  region        = local.region_vars.locals.region

  
  # Extract out common variables for reuse
  env    = local.environment_vars.locals.environment
  cidr = local.environment_vars.locals.cidr_block
  pub1_subnet = local.environment_vars.locals.pub1_subnet
  pub2_subnet = local.environment_vars.locals.pub2_subnet
  priv1_subnet = local.environment_vars.locals.priv1_subnet
  priv2_subnet = local.environment_vars.locals.priv2_subnet
  az1 = local.environment_vars.locals.az1
  az2 = local.environment_vars.locals.az2
}




# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules/vpc"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above

inputs = {
  env_prefix = "${local.env}" 
  cidr_block            = "${local.cidr}"
  pub1_subnet              = "${local.pub1_subnet}"     
  pub2_subnet              = "${local.pub2_subnet}"       
  priv1_subnet              = "${local.priv1_subnet}"      
  priv2_subnet         = "${local.priv2_subnet}"      
  az1     = "${local.az1}"      
  az2     = "${local.az2}"     
}

