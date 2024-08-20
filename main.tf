# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
}

#Filtrar zonas locais que não são suportadas atualmente 
# com grupos de nós gerenciados
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_caller_identity" "current" {}
