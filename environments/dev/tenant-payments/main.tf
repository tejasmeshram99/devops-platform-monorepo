module "payments_tenant" {
  source = "../../../modules/k8s-tenant"

  tenant_name  = "payments"
  environment  = "dev"
  cpu_limit    = "1"
  memory_limit = "1Gi"
  max_pods     = "5"

  labels = {
    team = "checkout-squad"
  }
}

output "tenant_info" {
  value = {
    namespace       = module.payments_tenant.namespace_name
    service_account = module.payments_tenant.service_account_name
  }
}
