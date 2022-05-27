resource "aws_instance" "worker" {
    count = 3
    ami = var.amis["us-east-1"]
    instance_type = var.inst_type
    key_name = var.chave-ssh
    associate_public_ip_address = true

  connection {
    type        = "ssh"
    user        = var.user
    private_key = file(var.chave-ssh)
    host        = self.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname k8s-worker${count.index}",
      "sudo echo 'k8s-worker${count.index}' > /etc/hostname",
      "echo '127.0.0.1 k8s-worker${count.index}' | sudo tee -a /etc/hosts",
      "sleep 30",
      "sudo apt update -y && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y && sudo apt install ansible -y",
    ]
  }

  provisioner "local-exec" {
    command = "sleep 10; echo $PATH; /usr/bin/ansible-playbook -i '${self.private_ip},' -u ${var.user} --private-key=${var.chave-ssh} --ssh-common-args='-o StrictHostKeyChecking=no' ansible/main.yaml"
  }
    
    tags = {
      "Name" = "k8s-worker${count.index}"
      Environment = terraform.workspace
    }
    subnet_id = aws_subnet.subnet01vpck8s.id
    vpc_security_group_ids = ["${aws_security_group.permite-ssh.id}"]
}
