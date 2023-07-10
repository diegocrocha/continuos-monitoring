terraform {
  backend "s3" {
    bucket = "continuos-monitoring-terraform"
    key    = "ci-terraform.tfstate"
    region = "us-east-1"
  }
}
