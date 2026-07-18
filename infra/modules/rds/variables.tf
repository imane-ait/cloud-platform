variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "eks_security_group_id" {
  type        = string
  description = "Security group ID du cluster EKS pour autoriser l'accès à la DB"
}
