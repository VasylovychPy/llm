resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "tech_task" {
  key_name   = "tech-task-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_openssh
  filename             = "${path.module}/.keys/tech-task-key"
  file_permission = "0400"
}