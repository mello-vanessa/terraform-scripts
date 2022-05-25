resource "aws_s3_bucket" "s3-state-remote" {
  bucket = "s3-state-remote"
  # Permissionamento do banco, não tem acesso publico.
  acl = "private"

  tags = {
    Name = "state-remote"
  }
}