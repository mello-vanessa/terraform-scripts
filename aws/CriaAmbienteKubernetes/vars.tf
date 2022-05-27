# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-0ed9277fb7eb570c9"
  }
}

variable "inst_ami" {
  type = string
  default =  "ami-0ed9277fb7eb570c9"
}

variable "inst_type" {
  type = string
  default =  "t2.medium"
}

variable "chave-ssh" {
   default = "HAProxy"
}

variable "path-chave-ssh" {
   default = "~/.ssh/id_rsa.pub"
}

variable "user" {
   default = "ubuntu"
}

// Busca e armazena meu IP em uma variável
data "http" "meuip"{
    url = "https://ipv4.icanhazip.com"
}
