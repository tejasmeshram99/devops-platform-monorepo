terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

locals {
  common_labels = merge(
    {
      "app.kubernetes.io/managed-by" = "terraform"
      "platform.company.com/tenant"  = var.tenant_name
      "platform.company.com/env"     = var.environment
    },
    var.labels
  )
}

# 1. Create Tenant Namespace
resource "kubernetes_namespace_v1" "tenant_ns" {
  metadata {
    name   = "${var.environment}-${var.tenant_name}"
    labels = local.common_labels
  }
}

# 2. Enforce Resource Quota (Hard Limits for the Namespace)
resource "kubernetes_resource_quota_v1" "tenant_quota" {
  metadata {
    name      = "${var.tenant_name}-resource-quota"
    namespace = kubernetes_namespace_v1.tenant_ns.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    hard = {
      "limits.cpu"      = var.cpu_limit
      "limits.memory"   = var.memory_limit
      "requests.cpu"    = var.cpu_limit
      "requests.memory" = var.memory_limit
      "pods"            = var.max_pods
    }
  }
}

# 3. Enforce Limit Range (Default Container Settings)
resource "kubernetes_limit_range_v1" "tenant_limits" {
  metadata {
    name      = "${var.tenant_name}-limit-range"
    namespace = kubernetes_namespace_v1.tenant_ns.metadata[0].name
    labels    = local.common_labels
  }

  spec {
    limit {
      type = "Container"

      default = {
        cpu    = "250m"
        memory = "256Mi"
      }

      default_request = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  }
}

# 4. Create Tenant Service Account
resource "kubernetes_service_account_v1" "tenant_sa" {
  metadata {
    name      = "${var.tenant_name}-sa"
    namespace = kubernetes_namespace_v1.tenant_ns.metadata[0].name
    labels    = local.common_labels
  }
}
