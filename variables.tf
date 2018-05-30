variable "availability_zones" {
  default = {
    "0" = "us-east-1a"
    "1" = "us-east-1c"
    "2" = "us-east-1b"
    "3" = "us-east-1d"
  }
}

variable "create_nat_gateway" {
  default = false
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "private_subnets" {
  default = {}
}

variable "subnets" {
  default = {
    "0" = "10.0.0.0/20"
    "1" = "10.0.16.0/20"
    "2" = "10.0.32.0/20"
    "3" = "10.0.48.0/20"
  }
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {}
