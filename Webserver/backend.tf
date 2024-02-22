# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "terra-back-ashu"
    key       = "webserver.tfstate"
    region    = "us-west-2"
  }
}