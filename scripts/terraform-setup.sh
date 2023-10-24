#!/bin/bash

echo "Initializing and applying Terraform configuration..."
cd ./terraform

# Prompt the user to input the prefix value
read -p "Enter the new prefix value: " new_prefix

# Prompt the user to input the AWS region
read -p "Enter the new AWS region: " new_region

# Define the path to your Terraform configuration files
state_tf_file="state.tf"
variables_tf_file="variables.tf"

# Replace the entire code block for "variable "prefix"" in the variables.tf file
sed -i "/variable \"prefix\"/,/}/c\\
variable \"prefix\" {\\
  description = \"A prefix to be added to resource names.\"\\
  type        = string\\
  default     = \"$new_prefix\"\\
}" "$variables_tf_file"

# Replace the entire code block for "variable "region"" in the variables.tf file
sed -i "/variable \"region\"/,/}/c\\
variable \"region\" {\\
  description = \"AWS region where the resources will be created\"\\
  type        = string\\
  default     = \"$new_region\"\\
}" "$variables_tf_file"

echo "Prefix and region values updated to: $new_prefix and $new_region"

terraform fmt

terraform init
terraform apply -auto-approve
