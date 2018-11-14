resource "aws_vpc" "pcf-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "pcf-public-subnet" {
  vpc_id     = "${aws_vpc.pcf-vpc.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.az}"
  map_public_ip_on_launch = true

  tags {
    Name = "pcf-public-subnet"
  }
}

resource "aws_subnet" "pcf-management-subnet" {
  vpc_id     = "${aws_vpc.pcf-vpc.id}"
  cidr_block = "10.0.16.0/28"
  availability_zone = "${var.az}"

  tags {
    Name = "pcf-management-subnet"
  }
}


resource "aws_subnet" "pcf-pas-subnet" {
  vpc_id     = "${aws_vpc.pcf-vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.az}"

  tags {
    Name = "pcf-pas-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.pcf-vpc.id}"

  tags {
    Name = "main"
  }
}

resource "aws_eip" "nateip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nateip.id}"
  subnet_id     = "${aws_subnet.pcf-public-subnet.id}"
}

resource "aws_route" "r" {
  route_table_id            = "${aws_vpc.pcf-vpc.default_route_table_id}"
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.pcf-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}

resource "aws_route_table_association" "nat" {
  subnet_id      = "${aws_subnet.pcf-pas-subnet.id}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}

resource "aws_route_table_association" "internet" {
  subnet_id      = "${aws_subnet.pcf-public-subnet.id}"
  route_table_id = "${aws_vpc.pcf-vpc.default_route_table_id}"
}

output "vpc_id" {
  value = "${aws_vpc.pcf-vpc.id}"
}

output "public_subnet" {
  value = "${aws_subnet.pcf-public-subnet.id}"
}
output "public_subnet_cidr" {
  value = "${aws_subnet.pcf-public-subnet.cidr_block}"
}

output "management_subnet" {
  value = "${aws_subnet.pcf-management-subnet.id}"
}
output "management_subnet_cidr" {
  value = "${aws_subnet.pcf-management-subnet.cidr_block}"
}

output "pas_subnet" {
  value = "${aws_subnet.pcf-pas-subnet.id}"
}
output "pas_subnet_cidr" {
  value = "${aws_subnet.pcf-pas-subnet.cidr_block}"
}
