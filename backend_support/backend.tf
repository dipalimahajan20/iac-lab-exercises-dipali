terraform {
  backend "s3" {
    bucket = "tw-dipali-iac-lab-tfstate"
    key    = "terraform.tfstate"
    region = "ap-south-1"

    dynamodb_table = "tw-dipali-iac-lab-tfstate-lock"
    encrypt        = true
  }
}