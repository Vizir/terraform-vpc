resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "external" {
  availability_zone       = "${lookup(var.availability_zones, count.index)}"
  cidr_block              = "${lookup(var.subnets, count.index)}"
  count                   = "${length(var.subnets)}"
  map_public_ip_on_launch = true
  vpc_id                  = "${aws_vpc.main.id}"

  tags {
    Name = "${var.vpc_name}-${count.index+1}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.vpc_name}"
  }
}

resource "aws_route" "external" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
}
