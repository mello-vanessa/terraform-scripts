# Cria IGW
resource "aws_internet_gateway" "igw01" {
    vpc_id = aws_vpc.vpc01.id

    tags = {
      "Name" = "igw01"
    }
}

/* Cria tabela de rotas
# Aqui acaba tendo que por essas tags, senão dá erro na criação, requer testar removendo um por um para validar qual requer mesmo*/
resource "aws_route_table" "rt01" {
    vpc_id =  aws_vpc.vpc01.id
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
