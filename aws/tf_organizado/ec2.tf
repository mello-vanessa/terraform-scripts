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
    ami = var.amis["us-east-1"]
    # Etapa 2: Escolha um tipo de instância
    instance_type = "t2.micro"
    # Chave SSH, cada região tem a sua, importa no EC2 
    key_name = var.chave-ssh
    # "Se subnet tá on com isso. não precisaria deste atributo na teoria, mas na prática só funcionou assim
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
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.chave-ssh
    associate_public_ip_address = true
    
    tags = {
      "Name" = "dev4"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
    depends_on = [aws_s3_bucket.baldinho-dev4]
}

resource "aws_instance" "dev5" {
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.chave-ssh
    associate_public_ip_address = true
    
    tags = {
      "Name" = "dev5"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}

# EC2 em outra regiao (Ohio), requer security groups e outra imagem
resource "aws_instance" "dev6" {
    provider = aws.us-east-2
    ami = var.amis["us-east-2"]
    instance_type = "t2.micro"
  # key_name = "terraform-virginia"
    key_name = var.chave-ssh
    associate_public_ip_address = true
    
    tags = {
      "Name" = "dev6"
    }
    subnet_id = aws_subnet.subnet02vpc02.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh-us-east-2.id}"]
    depends_on = [aws_dynamodb_table.tabela-db-us-east-2-homologacao]
}