terraform {
   backend "s3" {
     encrypt = "true"
     bucket = "cttraining-artifact"
     region = "us-east-1"
     key = "development/vpc/terraform.tfstate"
 }
}
