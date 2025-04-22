variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-2"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for EKS and Load Balancer"
  type        = list(string)
}

variable "node_instance_type" {
  description = "Instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "tags" {
  description = "Tags to be applied to resources"
  type = map(any)
}