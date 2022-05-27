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
curl -fsSL https://get.docker.com | bash
mkdir /etc/docker
touch /etc/docker/daemon.json
echo "{" > /etc/docker/daemon.json
echo "  \"exec-opts\": [\"native.cgroupdriver=systemd\"]," >> /etc/docker/daemon.json
echo "  \"log-driver\": \"json-file\","  >> /etc/docker/daemon.json
echo "  \"log-opts\": {"  >> /etc/docker/daemon.json
echo "    \"max-size\": \"100m\""  >> /etc/docker/daemon.json
echo "  },"  >> /etc/docker/daemon.json
echo "  \"storage-driver\": \"overlay2\""  >> /etc/docker/daemon.json
echo "}"  >> /etc/docker/daemon.json
EOF
  
  tags = {
    "Name"      = "k8s-worker${count.index}"
    Environment = terraform.workspace
  }

  subnet_id              = aws_subnet.subnet01vpck8s.id
  vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
