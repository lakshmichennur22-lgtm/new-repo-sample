variable "vpc_id" {
  description = "VPC ID to attach subnets"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID for route table"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of AZs to deploy subnets"
  type        = list(string)
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}
