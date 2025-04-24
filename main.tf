provider "aws" {
    profile="DevOps"
    region="ap-south-1"
}

data "aws_ami" "ami" {
    most_recent = true
    owners = ["099720109477"]
    filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250305"]
    }
}
output "ami_id" {
    value = data.aws_ami.ami.id
}


data "aws_availability_zones" "az" {
    state = "available"
  
}

resource "aws_vpc" "main" {
    cidr_block = "10.10.0.0/16"
    tags = {
      Name = "Main"
      Environment = "development"
    }
  
}

resource "aws_subnet" "public" {
    count = 1
    vpc_id = aws_vpc.main.id
    # cidr_block = element()
    availability_zone = element(data.aws_availability_zones.az,count.index)
  
}
resource "aws_instance" "public" {
    ami = data.aws_ami.ami.id
    instance_type = "t3.medium"
    key_name = "aws-sg-key-pair.pem"
    associate_public_ip_address = true
    availability_zone = "ap-south-1"
  
}