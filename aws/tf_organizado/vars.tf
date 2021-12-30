# Arquivo de variáveis

variable "amis" {
  type = map(string)
  default = {
      "us-east-1" = "ami-0ed9277fb7eb570c9"
      "us-east-2" = "ami-002068ed284fb165b"
  }
}

variable "chave-ssh" {
   default = "terraform-virginia"
}

/* Busca e armazena meu IP em uma variável
   O data é de data source, mesmo que a URL seja https, o tipo de datasource é http
   Então é sempre data - tipo - variavel de nome local
   Ou seja, neste caso um bloco do tipo dado "data" requisita que o terraform leia de uma origem de dados dada, como no caso o http e exporta
   este resultado para um nome local, uma variável local, no caso, "meuip"
*/
data "http" "meuip"{
    url = "https://ipv4.icanhazip.com"
}

/* Caso eu não coletasse dinamicamente, eu teria de por assim:
variable "cidrs_acesso_remoto" {
  type = list(string)
  default = [ "191.32.154.79/32","171.12.31.47" ]
}
*/