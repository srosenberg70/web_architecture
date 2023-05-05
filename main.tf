#defining the provider as aws
provider "aws" {
    region     = "${var.aws_region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

# Terraform Block
terraform {
    required_version = "~> 1.0.11"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    } 
}
