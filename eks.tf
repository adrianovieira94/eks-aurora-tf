module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  #entidade principal do cluster
  enable_cluster_creator_admin_permissions = true


  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
    coredns = {
      version           = "v1.11.1-eksbuild.8"
      resolve_conflicts = "OVERWRITE"
    }
    eks-pod-identity-agent = {
      version           = "v1.3.0-eksbuild.1"
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      version           = "v1.30.0-eksbuild.3"
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      version           = "v1.18.1-eksbuild.3"
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids


  cluster_security_group_additional_rules = {
    egress = {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    Office = {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = var.ips_central_blocks
      description = "All traffic Office Credisis"

    }



    /*  Add_rule_1 = {
      protocol    = -1
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks =  ["173.50.0.0/16"]
      description = "teste"
    } */


  }

  eks_managed_node_groups = {

    one = {
      name           = var.node_group_name
      instance_types = [var.instance_types]
      min_size       = 1
      max_size       = 3
      desired_size   = 3
      ami_type       = var.ami_type

      capacity_type = "ON_DEMAND"
      block_device_mappings = [
        {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = var.volume_size
            volume_type = "gp3"
            encrypted   = true
            kms_key_arn = module.eks.kms_key_arn


          }
        }
      ]

    }
  }

  tags = {
    Environment = var.ambiente
    Terraform   = "true"
    ManagedBy   = "Terraform"
  }

}

#Amazon EBS CSI driver
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

