locals {
  cluster_name = "${var.prefix_user}-foodtruck-v1"
}

data "aws_availability_zones" "available" {}

# Creating our VPC based on what environment its going to be used:
#  For Production, create a VPC with a 10.100.0.0/16 CIDR
#  For Staging, create a VPC with a 10.110.0.0/16 CIDR
#  For User Devs, create a VPC with a 10.120.0.0/16 CIDR
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name                 = "${var.prefix_user}-foodtruck-v1-vpc"
  azs                  = data.aws_availability_zones.available.names
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
# BEGIN ANSIBLE MANAGED BLOCK
reuse_nat_ips        = true
external_nat_ip_ids  = ["eipalloc-48d87f46", "eipalloc-74bd1a7a", "eipalloc-34b3143a",
  "eipalloc-4e8c2b40", "eipalloc-1f8e2911", "eipalloc-51882f5f", "eipalloc-8a882f84"]
cidr                 = "10.100.0.0/16"
private_subnets      = ["10.100.32.0/20", "10.100.48.0/20"]
public_subnets       = ["10.100.10.0/24", "10.100.20.0/24"]
# END ANSIBLE MANAGED BLOCK

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "Usage"                                       = "Public"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "Usage"                                       = "Private"
  }
}
