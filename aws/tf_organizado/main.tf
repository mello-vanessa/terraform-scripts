# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
    region = "us-east-1"
}
# Additional provider configuration for east 2 region; resources can
# reference this as `aws.west`.
provider "aws" {
  # Não pode ter dois providers com mesmo nome, cria aliases. 
    alias = "us-east-2"
    region = "us-east-2"
}