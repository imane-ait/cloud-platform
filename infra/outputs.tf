output "vpc_id" {
  description = "ID du VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Nom du cluster EKS"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "db_endpoint" {
  description = "Endpoint RDS"
  value       = module.rds.db_endpoint
}
