# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-04505e74c0741db8d"
  }
}

variable "inst_type" {
  type = string
  default =  "t2.medium"
}

variable "chave-ssh" {
   default = "HAProxy"
}

variable "key_file" {
  type        = string
  default     = "/home/ubuntu/.ssh/id_rsa"
  description = "Configure pem file on machine"
}

variable "user" {
   default = "ubuntu"
}

// Busca e armazena meu IP em uma variável
data "http" "meuip"{
    url = "https://ipv4.icanhazip.com"
}
