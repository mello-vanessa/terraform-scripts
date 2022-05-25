# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-0ed9277fb7eb570c9"
      "us-east-2" = "ami-002068ed284fb165b"
  }
}

variable "inst_ami" {
  type = string
  default =  "ami-0ed9277fb7eb570c9"
}

variable "inst_type" {
  type = string
  default =  "t2.micro"
}

variable "chave-ssh" {
   default = "terraform-virginia"
}

// Busca e armazena meu IP em uma variável
data "http" "meuip"{
    url = "https://ipv4.icanhazip.com"
}
