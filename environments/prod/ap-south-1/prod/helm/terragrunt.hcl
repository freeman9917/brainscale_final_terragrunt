 locals {

# eks_outputs = read_terragrunt_config(find_in_parent_folders("eks/terragrunt.hcl"))

#  # Automatically load region-level variables
#   region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))


#   # Extract the variables we need for easy access
#   region        = local.region_vars.locals.region

 }






# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../../../modules/helm"

}


dependency "eks" {
  config_path = "../eks"
    # skip_outputs   = true
       mock_outputs = {
       cluster_endpoint = "sample-cluster_endpoint"
       cluster_certificate_authority_data = "YnJhaW5zY2FsZQ=="
       cluster_name = "sample-cluster_name"
       app_path = "dev/applications"
     }
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above

inputs = {
  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  authority_data            = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_name             = dependency.eks.outputs.cluster_name
  app_path = "prod/applications"
}
generate "helm_provider" {
  path      = "helm-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF


provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.authority_data )
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
EOF
}