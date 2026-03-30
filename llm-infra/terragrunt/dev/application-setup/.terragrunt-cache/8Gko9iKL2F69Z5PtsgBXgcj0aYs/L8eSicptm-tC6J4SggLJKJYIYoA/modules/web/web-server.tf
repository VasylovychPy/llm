resource "aws_security_group" "web" {
  name        = "${var.env}-web-sg"
  description = "Security group for web instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  ingress {
    description = "Open WebUI"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  ingress {
    description     = "Prometheus remote write from LLM SG"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-web-sg"
  })
}

resource "aws_eip" "web" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.env}-web-eip"
  })
}

resource "aws_eip_association" "web" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
}

resource "aws_instance" "web" {
  ami                         = var.monitoring_web_ami_id
  instance_type               = var.web_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
  volume_size = 20
  volume_type = "gp3"
}

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
  llm_alb_dns = var.llm_alb_dns
    db_endpoint = var.db_endpoint
    db_port     = var.db_port
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
}))

  tags = merge(var.common_tags, {
    Name = "${var.env}-web"
  })
}