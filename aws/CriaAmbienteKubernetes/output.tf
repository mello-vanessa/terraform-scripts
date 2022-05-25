/* Arquivo output.tf usado para capturar saídas de execuções
*/

# Verificar se o IP é auto attachado na EC2
output "instance_public_ips" {
  value = aws_instance.dev.*.public_ip
}
