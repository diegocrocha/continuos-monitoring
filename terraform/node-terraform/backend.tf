terraform {
  backend "s3" {
    bucket = "continuos-monitoring-terraform"
    key    = "node-terraform.tfstate"
    region = "us-east-1"
  }
}
