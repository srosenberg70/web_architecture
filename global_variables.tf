variable "access_key" {
    description = "Access key to AWS console"
}
variable "secret_key" {
    description = "Secret key to AWS console"
}
variable "region" {
    description = "AWS region"
}

#AWS Region
variable "aws_region" {
    description = "Region in which AWS Resources will be created"
    type = string
    # default = "us-east-1"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Specifies environment"
  type        = string
  # default     = "dev"
}

variable "az_number" {
  # Assign a number to each AZ letter used in our configuration
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}

variable "asg_web_name" {
  description = "Specifies auto scaling group name"
  type        = string
}

variable "subnet_id" {
  description = "Specifies subnet id"
  type        = number
}

variable "subnet_asg_web_1" {
  description = "Specifies subnet id"
  type        = number
}


variable "subnet_asg_app_1" {
  description = "Specifies subnet id"
  type        = number
}

variable "public_subnets" {
  description = "Specifies subnet id"
  type        = string
}

variable "private_subnets" {
  description = "Specifies subnet id"
  type        = string
}