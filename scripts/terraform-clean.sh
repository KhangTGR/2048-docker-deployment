#!/bin/bash

echo "Destroying Terraform-managed resources..."
cd ./terraform

# Function to destroy resources
destroy_resources() {
    terraform destroy -auto-approve
}

# Function to remove S3 objects and buckets
remove_s3_resources() {
    local s3_bucket_name="$1"
    aws s3 rm "s3://${s3_bucket_name}" --recursive
}

# Destroy resources
destroy_resources

# Remove S3 objects and buckets
remove_s3_resources "$(terraform output application_bucket_name)"
remove_s3_resources "$(terraform output backend_bucket_name)"
