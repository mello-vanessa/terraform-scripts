# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-04902260ca3d33422"
      "us-east-2" = "ami-002068ed284fb165b"
  }
}

variable "teste" {
  
}