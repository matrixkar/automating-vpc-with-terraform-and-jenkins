resource "aws_vpc" "matrixkar-vpc" {
  cidr_block           = "${var.vpc-cidr-block}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "matrixkar-vpc-${var.environment}"
  }
}

resource "aws_subnet" "matrixkar-subnet-01" {
  availability_zone = "${var.region}a"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.public-subnets, 0)}"

  tags = {
    Name = "matrixkar-public-subnet-01"
  }
}

resource "aws_subnet" "matrixkar-subnet-02" {
  availability_zone = "${var.region}b"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.public-subnets, 1)}"

  tags = {
    Name = "matrixkar-public-subnet-02"
  }
}

resource "aws_subnet" "matrixkar-subnet-03" {
  availability_zone = "${var.region}c"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.public-subnets, 2)}"

  tags = {
    Name = "matrixkar-public-subnet-03"
  }
}

resource "aws_subnet" "matrixkar-subnet-04" {
  availability_zone = "${var.region}a"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.private-subnets, 0)}"

  tags = {
    Name = "matrixkar-private-subnet-01"
  }
}

resource "aws_subnet" "matrixkar-subnet-05" {
  availability_zone = "${var.region}b"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.private-subnets, 1)}"

  tags = {
    Name = "matrixkar-private-subnet-02"
  }
}

resource "aws_subnet" "matrixkar-subnet-06" {
  availability_zone = "${var.region}c"
  vpc_id            = "${aws_vpc.matrixkar-vpc.id}"
  cidr_block        = "${element(var.private-subnets, 2)}"

  tags = {
    Name = "matrixkar-private-subnet-03"
  }
}

resource "aws_internet_gateway" "matrixkar-internet-gateway" {
  vpc_id = "${aws_vpc.matrixkar-vpc.id}"

  tags = {
    Name = "matrixkar-igw"
  }
}

resource "aws_eip" "matrixkar-eip" {
  vpc = true
}

resource "aws_nat_gateway" "matrixkar-nat-gateway" {
  allocation_id = "${aws_eip.matrixkar-eip.id}"
  subnet_id     = "${aws_subnet.matrixkar-subnet-01.id}"

  tags = {
    Name = "matrixkar-nat-gateway-01"
  }

  depends_on = ["aws_internet_gateway.matrixkar-internet-gateway"]
}

resource "aws_route_table" "matrixkar-route-table-01" {
  vpc_id = "${aws_vpc.matrixkar-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.matrixkar-internet-gateway.id}"
  }

  tags = {
    Name = "matrixkar-route-table-01"
  }

  depends_on = ["aws_internet_gateway.matrixkar-internet-gateway", "aws_vpc.matrixkar-vpc"]
}

resource "aws_route_table" "matrixkar-route-table-02" {
  vpc_id = "${aws_vpc.matrixkar-vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.matrixkar-nat-gateway.id}"
  }

  tags = {
    Name = "matrixkar-route-table-02"
  }

  depends_on = ["aws_nat_gateway.matrixkar-nat-gateway", "aws_vpc.matrixkar-vpc"]
}

resource "aws_route_table_association" "matrixkar-route-table-association-01" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-01.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-01.id}"
}

resource "aws_route_table_association" "matrixkar-route-table-association-02" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-02.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-01.id}"
}

resource "aws_route_table_association" "matrixkar-route-table-association-03" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-03.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-01.id}"
}

resource "aws_route_table_association" "matrixkar-route-table-association-04" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-04.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-02.id}"
}

resource "aws_route_table_association" "matrixkar-route-table-association-05" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-05.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-02.id}"
}

resource "aws_route_table_association" "matrixkar-route-table-association-06" {
  subnet_id      = "${aws_subnet.matrixkar-subnet-06.id}"
  route_table_id = "${aws_route_table.matrixkar-route-table-02.id}"
}