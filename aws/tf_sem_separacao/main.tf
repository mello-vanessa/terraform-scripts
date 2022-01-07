provider "aws" {
    # Comentado pois deprecated na verssao 1.x
    #version = "~> 3.0"
    region = "us-east-1"
}

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

# Cria IGW
resource "aws_internet_gateway" "igw01" {
    vpc_id = aws_vpc.vpc01.id

    tags = {
      "Name" = "igw01"
    }
}

/* Cria tabela de rotas
# Aqui acaba tendo que por essas tags, senão dá erro na criação */
resource "aws_route_table" "rt01" {
    vpc_id =  aws_vpc.vpc01.id
    route = [ {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw01.id
    carrier_gateway_id         = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
    } ]
    tags = {
      "Name" = "rt01"
    }
}

# Cria entrada na tabela de rotas
resource "aws_route" "entrada01" {
    route_table_id            = aws_route_table.rt01.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igw01.id
}

# Vincula a RT na subnet que eu quero
resource "aws_route_table_association" "associacao01" {
    subnet_id = aws_subnet.subnet01vpc01.id
    route_table_id = aws_route_table.rt01.id
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

/* O resource tem um tipo e um nome
Tipo: aws_instance
Nome: dev 
Aqui eu vou criar o tipo de máquina que eu quero criar
pode fazer uma tabela e buscar dessa tabela as imagens
*/
resource "aws_instance" "dev" {
    # Criar 3 EC2
    count = 3
    # Etapa 1: Selecione uma Imagem de máquina da Amazon (AMI)
    ami = "ami-04902260ca3d33422"
    # Etapa 2: Escolha um tipo de instância
    instance_type = "t2.micro"
    # Chave SSH, cada região tem a sua, importa no EC2 
    key_name = "terraform-virginia"
    # "Se subnet tá on com isso. não precisaria deste atributo na teoria, mas deu erro e precisei adicionar na resource
    associate_public_ip_address = true
    
    # Tags da EC2
    tags = {
    # Vou criar três máquinas, dev1, dev2 e dev3
      "Name" = "dev${count.index}"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    # pode por mais de um SG em  uma instanci, então é uma lista
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}

# Criar um bucket e nova máquina e vincular um ao outro, é multi região

resource "aws_instance" "dev4" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    key_name = "terraform-virginia"
    associate_public_ip_address = true
    
    tags = {
      "Name" = "dev4"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
    depends_on = [aws_s3_bucket.baldinho-dev4]
}

resource "aws_instance" "dev5" {
    ami = "ami-04902260ca3d33422"
    instance_type = "t2.micro"
    key_name = "terraform-virginia"
    associate_public_ip_address = true
    
    tags = {
      "Name" = "dev5"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}

resource "aws_s3_bucket" "baldinho-dev4" {
  bucket = "baldinho-dev4"
  # Permissionamento do banco, não tem acesso publico.
  acl = "private"

  tags = {
    Name = "baldinho-dev4"
  }
}