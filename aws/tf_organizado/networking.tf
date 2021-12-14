# Cria IGW
resource "aws_internet_gateway" "igw01" {
    vpc_id = aws_vpc.vpc01.id

    tags = {
      "Name" = "igw01"
    }
}

/* Cria tabela de rotas
# Aqui acaba tendo que por esse monte de inutilidade, senão dá erro na criação */
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