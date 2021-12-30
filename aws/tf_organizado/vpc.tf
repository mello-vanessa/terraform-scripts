/* Busca e armazena meu IP em uma variável
   O data é de data source, mesmo que a URL seja https, o tipo de datasource é http
   Então é sempre data - tipo - variavel de nome local
   Ou seja, neste caso um bloco do tipo dado "data" requisita que o terraform leia de uma origem de dados dada, como no caso o http e exporta
   este resultado para um nome local, uma variável local, no caso, "meuip"
*/
data "http" "meuip"{
    url = "https://ipv4.icanhazip.com"
}

/* Cria VPC. O tipo é predefinido, o nome, eu dou o que eu quiser, no caso, vpc01
   Neste caso é um bloco do tipo recurso "resource", origem do tipo "aws_vpc" e o nome da variável local é "vpc01"
*/
resource "aws_vpc" "vpc01" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      "Name" = "vpc01"
    }
}

# Cria subnet da VPC
resource "aws_subnet" "subnet01vpc01" {
    # tipo e nome setado no resource anterior, separado por um ponto
    vpc_id = aws_vpc.vpc01.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = true

    tags = {
      "Name" = "subnet01"
    }
}

# Cria VPC. O tipo é predefinido, o nome, eu dou o que eu quiser, no caso, vpc01
resource "aws_vpc" "vpc02" {
    provider = aws.us-east-2
    cidr_block = "10.2.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      "Name" = "vpc02"
    }
}
# Cria subnet da VPC
resource "aws_subnet" "subnet02vpc02" {
    provider = aws.us-east-2
    # tipo e nome setado no resource anterior, separado por um ponto
    vpc_id = aws_vpc.vpc02.id
    cidr_block = "10.2.1.0/24"
    map_public_ip_on_launch = true

    tags = {
      "Name" = "subnet02"
    }
}

resource "aws_security_group" "permite-ssh" {
  name        = "permite-ssh"
  description = "Permite SSH no trafego de entrada"
  vpc_id      = aws_vpc.vpc01.id

  ingress {
    description      = "SSH para a VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
# ["177.22.178.179/32", 1.1.1.0/24]
    cidr_blocks      = ["${chomp(data.http.meuip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "permite-ssh"
  }
}

# SG us-east-2
resource "aws_security_group" "permite-ssh-us-east-2" {
  provider = aws.us-east-2
  name        = "permite-ssh"
  description = "Permite SSH no trafego de entrada"
  vpc_id      = aws_vpc.vpc02.id

  ingress {
    description      = "SSH para a VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.meuip.body)}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "permite-ssh"
  }
}