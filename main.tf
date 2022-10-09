data "aws_region" "current" {}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-005e54dee72cc1d00"
  instance_type = "t3.micro"
  
  tags = {
    Name        = "webserver-${count.index}"
    Environment = "local"
  }
}

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
  count   = 2
  zone_id = aws_route53_zone.primary.id
  name    = "webserver-${count.index}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.web[count.index].public_ip]
}