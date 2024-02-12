resource "aws_vpc" "vpc" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  tags = {
    Name = "Niv Gabay"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Niv Gabay"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Niv Gabay"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    Name = "Niv Gabay"
  }
}

resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Niv Gabay"
  }
}

resource "aws_instance" "instance" {
  ami                         = "ami-03cceb19496c25679"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_public.id
  security_groups             = [aws_security_group.security_group.id]
  associate_public_ip_address = true

  tags = {
    Name = "Niv Gabay"
  }

  user_data = <<-EOF
              #!/bin/bash

              # install requirements
              sudo yum update
              sudo yum install docker -y
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo yum install -y git

              # clone repository
              git clone https://github.com/n1vgabay/labos-devops-task.git
              cd /labos-devops-task
              
              # setup to run
              sudo usermod -aG docker $USER
              sudo systemctl restart docker

              # run
              sudo docker-compose up -d
              EOF
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}