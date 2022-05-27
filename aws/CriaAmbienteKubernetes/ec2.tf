resource "aws_instance" "worker" {
  count                       = 1
  ami                         = var.amis["us-east-1"]
  instance_type               = var.inst_type
  key_name                    = var.chave-ssh
  associate_public_ip_address = true

  user_data                   = <<EOF
#!/bin/bash -xe
touch /etc/modules-load.d/k8s.conf
echo br_netfilter >> /etc/modules-load.d/k8s.conf
echo ip_vs >> /etc/modules-load.d/k8s.conf
echo ip_vs_rr >> /etc/modules-load.d/k8s.conf
echo ip_vs_sh >> /etc/modules-load.d/k8s.conf
echo ip_vs_wrr >> /etc/modules-load.d/k8s.conf
echo nf_conntrack_ipv4 >> /etc/modules-load.d/k8s.conf
apt update
apt upgrade -y
touch /tmp/daemon.json
echo "{" > /tmp/daemon.json
echo "  \"exec-opts\": [\"native.cgroupdriver=systemd\"]," >> /tmp/daemon.json
echo "  \"log-driver\": \"json-file\","  >> /tmp/daemon.json
echo "  \"log-opts\": {"  >> /tmp/daemon.json
echo "    \"max-size\": \"100m\""  >> /tmp/daemon.json
echo "  },"  >> /tmp/daemon.json
echo "  \"storage-driver\": \"overlay2\""  >> /tmp/daemon.json
echo "}"  >> /tmp/daemon.json
apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list; exit
apt-get update
apt-get install -y kubelet kubeadm kubectl
swapoff -a
EOF
  
  tags = {
    "Name"      = "k8s-worker${count.index}"
    Environment = terraform.workspace
  }

  subnet_id              = aws_subnet.subnet01vpck8s.id
  vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
