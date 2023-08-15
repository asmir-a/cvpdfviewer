terraform {
  cloud {
    organization = "asmir4development-org"
    workspaces {
      name = "prototyping"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    required_version = ">= 1.5.5"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_security_group" "sg_cvpdfviewer" {
  name        = "initial cvpdfviewer configuration"
  description = "just ssh for now"

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "cvpdfviewer"
  }
}

resource "aws_instance" "ec2_cvpdfviewer" {
  ami           = "ami-0c9c942bd7bf113a2"
  instance_type = "t2.micro"
  key_name      = "cvpdfviewer"

  vpc_security_group_ids = [aws_security_group.sg_cvpdfviewer.id]

  tags = {
    Name = "cvpdfviewer"
  }
}