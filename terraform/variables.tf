# ==================================
#   Project general Configuration
# ==================================
variable "prefix" {
  description = "A prefix to be added to resource names."
  type        = string
  default     = "pynamo"
}

variable "region" {
  description = "AWS region where the resources will be created"
  type        = string
  default     = "us-east-1"
}



# ==================================
#   AWS Credentials Configuration
# ==================================
variable "profile" {
  description = "AWS named profile to use for authentication. This profile should be configured in your AWS CLI or SDK credentials file."
  type        = string
  default     = "default"
}



# ==================================
#   S3 Application Configuration
# ==================================
variable "s3_bucket_application" {
  description = "Configuration settings for the S3 application bucket"

  type = object({
    name = string
  })

  default = {
    name = "game-2048-application"
  }
}



# ==========================
#   Nexwork Configuration
# ==========================
variable "network" {
  description = "Configuration settings for the AWS VPC."

  type = object({
    cidr_block                 = string
    name                       = string
    tags                       = map(string)
    public_subnets_cidr_block  = list(string)
    private_subnets_cidr_block = list(string)
    availability_zones         = list(string)
  })

  default = {
    cidr_block                 = "10.0.0.0/16"
    name                       = "docker-app-vpc"
    tags                       = {}
    public_subnets_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
    availability_zones         = ["us-east-1a", "us-east-1b"]
  }
}



# =====================================
#   Elastic Beanstalk Configuration
# =====================================
variable "elastic_beanstalk_application" {
  description = "Configuration settings for the Elastic Beanstalk application"

  type = object({
    name        = string
    description = string
    version     = string
    key         = string
  })

  default = {
    name        = "docker-engine-application"
    description = "An application built for docker container"
    version     = "v1.0.0"
    key         = "app.zip"
  }
}

variable "elastic_beanstalk_environment" {
  description = "Configuration settings for the Elastic Beanstalk environment"

  type = object({
    name                = string
    tier                = string
    solution_stack_name = string
    description         = string
  })

  default = {
    name                = "docker-engine-env"
    tier                = "WebServer"
    solution_stack_name = "64bit Amazon Linux 2023 v4.0.1 running Docker"
    description         = "Environment for Docker container"
  }
}
