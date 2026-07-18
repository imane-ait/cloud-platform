output "cluster_name" {
  description = "Nom du cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "eks_security_group_id" {
  description = "Security group ID du cluster EKS"
  value       = aws_security_group.eks.id
}

output "cluster_certificate_authority" {
  description = "Certificate authority du cluster EKS"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}
