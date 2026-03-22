terraform {
  backend "s3" {
    bucket         = "weather-pipeline-tfstate"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
