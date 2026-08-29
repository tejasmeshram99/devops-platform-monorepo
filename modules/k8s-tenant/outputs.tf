output "namespace_name" {
  value       = kubernetes_namespace_v1.tenant_ns.metadata[0].name
  description = "The name of the created Kubernetes namespace."
}

output "service_account_name" {
  value       = kubernetes_service_account_v1.tenant_sa.metadata[0].name
  description = "The name of the tenant's primary Service Account."
}

output "resource_quota_name" {
  value       = kubernetes_resource_quota_v1.tenant_quota.metadata[0].name
  description = "The name of the enforced Resource Quota object."
}
