
# aws_security_group" "pcf-ops-manager-security-group
resource "aws_security_group" "bosh-director-sg" {
  name        = "bosh-director-sg"
  description = "bosh-director-security-group"
  vpc_id      = "${var.vpc}"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "SSH access from CLI"
  }

  ingress {
    from_port   = 6868
    to_port     = 6868
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "BOSH Agent access from CLI"
  }

  ingress {
    from_port   = 25555
    to_port     = 25555
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "BOSH Director access from CLI"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Management and data access"
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
    description = "Management and data access"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "Allow Outbound Access"
  }

  tags {
    Name = "bosh-director-security-group"
  }
}

resource "aws_security_group" "jumpbox-sg" {
  name        = "jumpbox-sg"
  description = "jumpbox-security-group"
  vpc_id      = "${var.vpc}"


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.yourip}"]
    description = "All access from user"
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description = "Allow Outbound Access"
  }
}

output "jumpbox_security_group" {
  value = "${aws_security_group.jumpbox-sg.id}"
}

output "bosh_security_group" {
  value = "${aws_security_group.bosh-director-sg.id}"
}
