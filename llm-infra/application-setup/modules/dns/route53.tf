resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(var.common_tags, {
    Name = var.domain_name
  })
}

resource "aws_route53_zone" "internal" {
  name = "internal.local"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(var.common_tags, {
    Name = "${var.env}-internal"
  })
}

resource "aws_route53_record" "web" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [var.web_public_ip]
}

resource "aws_route53_record" "prometheus" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "prometheus"
  type    = "A"
  ttl     = 300
  records = [var.web_private_ip]
}