resource "aws_instance" "worker" {
    count = 3
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
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
sudo apt update
sudo apt upgrade -y
curl -fsSL https://get.docker.com | bash
cat > /etc/docker/daemon.json <<EOD
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOD
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo swapoff -a
sudo kubeadm config images pull
sudo kubeadm init
EOF
    
    tags = {
      "Name" = "k8s-worker${count.index}"
      Environment = terraform.workspace
    }
    subnet_id = aws_subnet.subnet01vpck8s.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
