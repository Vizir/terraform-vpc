output "availability_zones" {
  value = "${var.availability_zones}"
}

output "availability_zones_names" {
  value = "${join(",", values(var.availability_zones))}"
}

output "subnets" {
  value = "${var.subnets}"
}

output "subnet_ids" {
  value = "${join(",", aws_subnet.external.*.id)}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}
