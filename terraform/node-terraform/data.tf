data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:Name"
    values = ["default-vpc"]
  }
}

data "aws_ami" "redhat_ami" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-026ebd4cfe2c043b2"]
  }
}

data "aws_subnet" "default_subnet" {
  vpc_id            = data.aws_vpc.default_vpc.id
  filter {
    name   = "tag:Name"
    values = ["default-subnet-public1-us-east-1a"]
  }
}

data "aws_security_group" "default_sg" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}