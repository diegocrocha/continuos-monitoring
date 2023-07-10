module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name                   = "ci-server"
  ami                    = data.aws_ami.redhat_ami.id
  instance_type          = "t2.micro"
  key_name               = "chave-ci"
  monitoring             = true
  vpc_security_group_ids = [module.ci_sg.security_group_id]
  subnet_id              = aws_subnet.subnet_continuos_monitoring.id
  associate_public_ip_address = true

  tags = {
    Name   = "CI-Server"
  }
}