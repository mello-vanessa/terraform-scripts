# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-0ed9277fb7eb570c9"
      "us-east-2" = "ami-0a5899928eba2e7bd"
  }
}
