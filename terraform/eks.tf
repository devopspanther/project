module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.9.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "FoodTruck v1"
    Email       = "${var.prefix_user}@securitycompass.com"
  }
  #cluster_iam_role_name = "eks-iam-role-policy"
  vpc_id                                = module.vpc.vpc_id
  enable_irsa                           = true
  cluster_endpoint_private_access       = true
  cluster_endpoint_public_access        = true
  cluster_endpoint_private_access_cidrs = ["10.0.0.0/8"]
  wait_for_cluster_timeout = "600"
# BEGIN ANSIBLE MANAGED BLOCK
  cluster_endpoint_public_access_cidrs  = ["142.112.83.2/32", "34.198.218.0/24", "174.142.184.242/32",
                                          "68.182.135.114/32", "3.213.79.176/32", "34.206.230.175/32",
                                          "52.203.223.215/32", "54.83.74.180/32"]

  map_roles = [
    {
      rolearn  = "arn:aws:iam::757687274468:role/dso_admins"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "arn:aws:iam::757687274468:role/dso_admins"
      username = "cluster-creator"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "arn:aws:iam::757687274468:role/dso_developers"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = "arn:aws:iam::757687274468:role/dso_developers"
      username = "cluster-creator"
      groups   = ["system:masters", "system:bootstrappers", "system:nodes"]
    },
  ]
# END ANSIBLE MANAGED BLOCK
  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 40
    additional_tags = {
          key                 = "Managed"
          value               = "True"
    }
  }

  node_groups = {
    worker-nodes = {
      name                          = "${var.prefix_user}-workers"
      instance_types                = ["m4.xlarge"]
      desired_capacity              = 2
      max_capacity                  = 10
      min_capacity                  = 1
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
      #additional_userdata           = base64encode(data.template_file.launch_template_userdata_osd.rendered)
    }
  }
}
#data "template_file" "launch_template_userdata_osd" {
#  template = file("templates/userdata.sh")
#}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
