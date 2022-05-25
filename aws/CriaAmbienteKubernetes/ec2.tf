resource "aws_instance" "worker" {
    count = 3
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.chave-ssh
    associate_public_ip_address = true
    
    tags = {
      "Name" = "worker${count.index}"
    }
    subnet_id = aws_subnet.subnet01vpc01.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
