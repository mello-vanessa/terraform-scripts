# Cria VPC. O tipo é predefinido, o nome, eu dou o que eu quiser, no caso, vpc01
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
    cidr_blocks      = ["177.22.178.134/32"]
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