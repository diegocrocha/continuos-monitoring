resource "aws_vpc" "vpc_continuos_monitoring" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-continuos-monitoring"
  }
}

resource "aws_network_acl" "ci_network_acl" {
  vpc_id = aws_vpc.vpc_continuos_monitoring.id

  tags = {
    Name = "CI-Network-ACL"
  }
}

resource "aws_network_acl_rule" "ssh_inbound" {
  network_acl_id = aws_network_acl.ci_network_acl.id

  rule_number  = 100
  protocol     = "6"  # TCP
  rule_action  = "allow"
  egress       = false
  cidr_block   = "0.0.0.0/0"
  from_port    = 22
  to_port      = 22
}

resource "aws_internet_gateway" "ci_internet_gateway" {
  vpc_id = aws_vpc.vpc_continuos_monitoring.id

  tags = {
    Name = "CI-Internet-Gateway"
  }
}

resource "aws_route_table" "ci_route_table" {
  vpc_id = aws_vpc.vpc_continuos_monitoring.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ci_internet_gateway.id
  }
}

resource "aws_subnet" "subnet_continuos_monitoring" {
  vpc_id                  = aws_vpc.vpc_continuos_monitoring.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-continuos-monitoring"
  }
}

resource "aws_route_table_association" "ci_subnet_association" {
  subnet_id      = aws_subnet.subnet_continuos_monitoring.id
  route_table_id = aws_route_table.ci_route_table.id
}

resource "aws_route" "ci_subnet_route" {
  route_table_id            = aws_route_table.ci_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.ci_internet_gateway.id
}

module "ci_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "CI-SG"
  description = "Security group for CI instance"
  vpc_id      = data.aws_vpc.ci_vpc.id

}

resource "aws_security_group_rule" "http_ingress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP traffic"
}

resource "aws_security_group_rule" "prometheus_ingress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Prometheus traffic (9090)"
}

resource "aws_security_group_rule" "prometheus_exporter_ingress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Prometheus Exporter traffic (9100)"
}

resource "aws_security_group_rule" "ssh_ingress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH traffic"
}

resource "aws_security_group_rule" "grafana_ingress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow Grafana traffic"
}

resource "aws_security_group_rule" "http_egress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound HTTP traffic"
}

resource "aws_security_group_rule" "https_egress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound HTTPS traffic"
}

resource "aws_security_group_rule" "grafana_egress" {
  security_group_id = module.ci_sg.security_group_id
  type              = "egress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow outbound Grafana traffic"
}
