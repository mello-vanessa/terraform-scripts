terraform {
  required_version = ">= 0.15.0"

  backend "s3" {
    bucket = "state-remote"
    key    = "terraform/"
    region = "us-east-1"
  }
}
