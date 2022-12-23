resource "aws_security_group" "all_worker_mgmt" {
  #checkov:skip=CKV2_AWS_5: Its been used by the EKS Module, not sure why Chekov didn't pick this up
  #checkov:skip=CKV_AWS_23: It already has a good enough description
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
  description = "SG to allow inbound connection from SC network and internal VPC"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      "142.112.83.2/32",
      "174.142.184.242/32",
      "68.182.135.114/32",
      "3.213.79.176/32",
      "34.206.230.175/32",
      "52.203.223.215/32",
      "54.83.74.180/32",
    ]
  }
}

resource "aws_security_group" "nfs_eks_efs" {
  #checkov:skip=CKV_AWS_23: It already has a good enough description
  name_prefix = "nfs_eks_efs"
  vpc_id      = module.vpc.vpc_id
    description = "SG to allow inbound connection from internal VPC"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
    ]
  }
}

resource "aws_security_group" "ec2_instances" {
  #checkov:skip=CKV2_AWS_5: Its been used by the EKS Module, not sure why Chekov didn't pick this up
  #checkov:skip=CKV_AWS_23: It already has a good enough description
  name_prefix = "ec2_instances"
  vpc_id      = module.vpc.vpc_id
  description = "SG to allow inbound connection from SC network and internal VPC"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
      "142.112.83.2/32",
      "174.142.184.242/32",
      "68.182.135.114/32",
      "3.213.79.176/32",
      "34.206.230.175/32",
      "52.203.223.215/32",
      "54.83.74.180/32",
    ]
  }
}