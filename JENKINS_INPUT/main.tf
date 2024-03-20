terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
  # Configuration options
}

resource "aws_instance" "instance" {
ami           = "ami-007020fd9c84e18c7"
instance_type = "t2.micro"

  tags = {
    Name = "Hello-ASFIYA"
  }
}


