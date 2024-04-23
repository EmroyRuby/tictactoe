terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file("${path.module}/my-key.pub")
}

resource "aws_security_group" "instances" {
  name = "instance-security-group"
  description = "security groups"

  ingress{
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress{
    from_port = 5173
    to_port = 5173
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.instances.id ]
  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "TicTacToeGame"
  }
}
