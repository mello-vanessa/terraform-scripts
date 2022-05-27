sudo apt update
sudo apt upgrade -y
curl -fsSL https://get.docker.com | bash
sudo mv /tmp/daemon.json  /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo docker info | grep -i cgroup
#Se a saída foi Cgroup Driver: systemd, tudo certo!

sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo su;  echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list; exit
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo swapoff -a

sudo kubeadm config images pull
sudo kubeadm init