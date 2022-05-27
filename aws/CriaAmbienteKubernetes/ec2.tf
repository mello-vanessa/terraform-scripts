resource "aws_instance" "worker" {
  count                       = 1
  ami                         = var.amis["us-east-1"]
  instance_type               = var.inst_type
  key_name                    = var.chave-ssh
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
sleep 60
sudo mkdir /etc/docker
sudo touch /etc/docker/daemon.json
sudo echo "{" > /etc/docker/daemon.json
sudo echo "  \"exec-opts\": [\"native.cgroupdriver=systemd\"]," >> /etc/docker/daemon.json
sudo echo "  \"log-driver\": \"json-file\","  >> /etc/docker/daemon.json
sudo echo "  \"log-opts\": {"  >> /etc/docker/daemon.json
sudo echo "    \"max-size\": \"100m\""  >> /etc/docker/daemon.json
sudo echo "  },"  >> /etc/docker/daemon.json
sudo echo "  \"storage-driver\": \"overlay2\""  >> /etc/docker/daemon.json
sudo echo "}"  >> /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo su;  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list; exit
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo swapoff -a
sudo kubeadm config images pull
sudo kubeadm init
EOF
  
  tags = {
    "Name"      = "k8s-worker${count.index}"
    Environment = terraform.workspace
  }

  subnet_id              = aws_subnet.subnet01vpck8s.id
  vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
