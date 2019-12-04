variable "access_key" {}
variable "secret_key" {}
variable "environment" {}
variable "vpc-cidr-block" {}

variable "region" {
  default = "us-east-1"
}

variable "public-subnets" {
  type = "list"
}

variable "private-subnets" {
  type = "list"
}
