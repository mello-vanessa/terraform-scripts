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

/*
terraform {
  backend "local" {
    path = "/home/vanessa/terraform-scripts/aws/tf_organizado/terraform.tfstate"
  }
}
*/