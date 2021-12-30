# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "organizacao-vanessa"

    workspaces {
      name = "organizacao-vanessa"
    }
  }
}
