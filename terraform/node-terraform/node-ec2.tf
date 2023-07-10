module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "node-server"
  ami                    = data.aws_ami.redhat_ami.id
  instance_type          = "t2.micro"
  key_name               = "chave-ci"
  monitoring             = true
  vpc_security_group_ids = [data.aws_security_group.default_sg.id]
  subnet_id              = data.aws_subnet.default_subnet.id
  associate_public_ip_address = true

  tags = {
    Name   = "Node-Server"
  }
}