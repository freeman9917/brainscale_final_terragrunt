# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "prod"
  cidr_block = "10.1.0.0/16"
  pub1_subnet = "10.1.101.0/24"
  pub2_subnet = "10.1.102.0/24"
  priv1_subnet = "10.1.1.0/24"
  priv2_subnet = "10.1.2.0/24"
  az1 = "ap-south-1a" 
  az2 = "ap-south-1b" 
}





