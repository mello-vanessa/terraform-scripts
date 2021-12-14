resource "aws_s3_bucket" "baldinho-dev4" {
  bucket = "baldinho-dev4"
  # Permissionamento do banco, não tem acesso publico.
  acl = "private"

  tags = {
    Name = "baldinho-dev4"
  }
}