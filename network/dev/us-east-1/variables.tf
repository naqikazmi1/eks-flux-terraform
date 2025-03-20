variable "vpc" {
  description = "VPC configurations"
  type    = any
  default = {}
}

variable "region" {
  description = "Name of the region"
  type    = string
  default = "us-east-1"
}

variable "number_of_az" {
  description = "Number of AZs to use in the region"
  type    = number
  default = 2
}

# Each subnet will be /24 masked if VPC cidr is /16. This adds the 8 into /16 to create /24 subnet bits.
variable "subnet_bits" {
  description = "The number of subnet bits that we want to use for our subnets"
  type = number
  default = 8
}

variable "identifier" {
  description = "Name of the project"
  type    = string
  default = "abc"
}

variable "env" {
  description = "Name of the environment"
  type    = string
  default = "prod"
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}
