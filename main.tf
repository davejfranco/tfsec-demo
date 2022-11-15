data "aws_region" "current" {}

#tfsec:ignore:aws-ec2-enforce-http-token-imds
resource "aws_instance" "web" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t3.micro"


  root_block_device {
    encrypted = true
  }
  tags = {
    Name        = "webserver"
    Environment = "local"
  }
}

#tfsec:ignore:aws-ec2-enforce-http-token-imds
resource "aws_instance" "db" {
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t3.micro"


  tags = {
    Name        = "MysqlDB"
    Environment = "local"
  }
}

resource "aws_route53_zone" "primary" {
  name = "daveops.sh"
}

resource "aws_route53_record" "web" {

  zone_id = aws_route53_zone.primary.id
  name    = "webserver"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web.public_ip]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.primary.id
  name    = "db"
  type    = "A"
  ttl     = 300
  records = [aws_instance.db.public_ip]
}