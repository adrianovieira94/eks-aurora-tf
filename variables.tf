# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}


variable "account_id" {
  description = "Id da conta da AWS"
  type        = string

}


variable "cluster_name" {
  description = "Definir nome do cluster"
  type        = string
}

variable "vpc_id" {
  description = "Definir id da vpc"
  type        = string

}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS cluster"
  type        = list(string)

}

variable "node_group_name" {
  description = "Definir nome do node group"
  type        = string

}


variable "instance_types" {
  description = "Definir tipo de instancias"
  type        = string

}

variable "ami_type" {
  description = "Definir tipo de instancias"
  type        = string
  default     = "AL2_x86_64"
}

variable "volume_size" {
  description = "Definir tamanho do volume do EBS"
  type        = string

}


variable "ips_central_blocks" {
  description = "Redes da Credisis Central Office"
  type        = list(string)
  default     = ["172.30.0.0/16", "172.31.0.0/16", "172.17.0.0/16"]
}

variable "ambiente" {
  description = "Ambiente hml/prd"
  type        = string
}