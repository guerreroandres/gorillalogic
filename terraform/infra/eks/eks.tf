resource "random_string" "suffix" {
  length  = 4
  special = false
}

locals {
  cluster_name = "eks-${var.environment}-tf-${random_string.suffix.result}"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 18.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.23"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  tags = {
    Environment = var.environment
  }

  eks_managed_node_groups = {
    # blue = {}
    develop-eks-ng1 = {
      min_size     = 1
      max_size     = 2
      desired_size = 2

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }
  # depends_on = [
  #   module.develop-vpc
  # ]
}

# module "eks_auth" {
#   source = "aidanmelen/eks-auth/aws"
#   eks    = module.eks

#   # map_roles = [
#   #   {
#   #     rolearn  = "arn:aws:iam::66666666666:role/role1"
#   #     username = "role1"
#   #     groups   = ["system:masters"]
#   #   },
#   # ]

#   map_users = [
#     {
#       userarn  = "arn:aws:iam::032209931663:user/githubactions"
#       username = "githubactions"
#       groups   = ["system:masters"]
#     }
#   ]

  # map_accounts = [
  #   "777777777777",
  #   "888888888888",
  # ]
# }