terraform {
  required_version = ">= 0.15.0"

  backend "s3" {
    bucket = aws_s3_bucket.s3-state-remote.id
    key    = var.s3-state-remote
    region = "us-east-1"
  }
}
