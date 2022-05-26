resource "aws_instance" "worker" {
    count = 3
    ami = var.amis["us-east-1"]
    instance_type = var.inst_type
    key_name = var.chave-ssh
    associate_public_ip_address = true
    user_data                   = <<EOF
#!/bin/bash -xe
sudo touch /etc/modules-load.d/k8s.conf
sudo echo br_netfilter >> /etc/modules-load.d/k8s.conf
sudo echo ip_vs >> /etc/modules-load.d/k8s.conf
sudo echo ip_vs_rr >> /etc/modules-load.d/k8s.conf
sudo echo ip_vs_sh >> /etc/modules-load.d/k8s.conf
sudo echo ip_vs_wrr >> /etc/modules-load.d/k8s.conf
sudo echo nf_conntrack_ipv4 >> /etc/modules-load.d/k8s.conf
EOF
    
    tags = {
      "Name" = "k8s-worker${count.index}"
      Environment = terraform.workspace
    }
    subnet_id = aws_subnet.subnet01vpck8s.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
