resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "external" {
  availability_zone       = "${lookup(var.availability_zones, count.index)}"
  cidr_block              = "${lookup(var.subnets, count.index)}"
  count                   = "${length(var.subnets)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.vpc_name}-${count.index+1}"
  }
}

resource "aws_subnet" "private" {
  availability_zone       = "${lookup(var.availability_zones, count.index)}"
  cidr_block              = "${lookup(var.private_subnets, count.index)}"
  count                   = "${length(var.private_subnets)}"
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.vpc_name}-private-${count.index+1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_route_table" "private" {
  count  = "${length(var.private_subnets) > 0 ? 1 : 0}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route" "external" {
  count                  = "${length(aws_route_table.private)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
  route_table_id         = "${aws_route_table.private[count.index].id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(aws_route_table.private)}"
  route_table_id = "${aws_route_table.private[count.index].id}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
}

resource "aws_eip" "nat" {
  vpc   = true

  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

resource "aws_nat_gateway" "private" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.external.0.id}"

  depends_on = ["aws_internet_gateway.main"]
}

resource "aws_route" "nat_gateway" {
  count                  = "${length(aws_route_table.private)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.private[count.index].id}"
  route_table_id         = "${aws_route_table.private[count.index].id}"
}
