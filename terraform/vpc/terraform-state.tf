terraform {
   backend "s3" {
     encrypt = "true"
     bucket = "hsbc06-state"
     region = "us-east-1"
     key = "vpc/development/terraform.tfstate"
 }
}
