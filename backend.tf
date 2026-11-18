terraform {
  backend "s3" {
    bucket         = "tf-state-saipe-us-east-1"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}