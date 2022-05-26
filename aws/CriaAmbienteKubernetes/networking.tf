# Cria IGW
resource "aws_internet_gateway" "igwk8s" {
    vpc_id = aws_vpc.vpck8s.id

    tags = {
      "Name" = "igwk8s"
      Environment = terraform.workspace
    }
}

/* Cria tabela de rotas
# Aqui acaba tendo que por essas tags, senão dá erro na criação, requer testar removendo um por um para validar qual requer mesmo*/
resource "aws_route_table" "rtk8s" {
    vpc_id =  aws_vpc.vpck8s.id
    tags = {
      "Name" = "rtk8s"
      Environment = terraform.workspace
    }
}

# Cria entrada na tabela de rotas
resource "aws_route" "entrada01" {
    route_table_id            = aws_route_table.rtk8s.id
    destination_cidr_block    = "0.0.0.0/0"
    gateway_id                = aws_internet_gateway.igwk8s.id
}

# Vincula a RT na subnet que eu quero
resource "aws_route_table_association" "associacao01" {
    subnet_id = aws_subnet.subnet01vpck8s.id
    route_table_id = aws_route_table.rtk8s.id
}
