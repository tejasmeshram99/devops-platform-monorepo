variable "tenant_name" {
  type        = string
  description = "The name of the tenant/team (used for namespace and resource naming)."

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.tenant_name))
    error_message = "Tenant name must consist of lower case alphanumeric characters or '-'."
  }
}

variable "environment" {
  type        = string
  description = "Target deployment environment (e.g., dev, staging, prod)."
  default     = "dev"
}

variable "cpu_limit" {
  type        = string
  description = "Maximum aggregate CPU limit for the namespace (e.g., '2', '500m')."
  default     = "2"
}

variable "memory_limit" {
  type        = string
  description = "Maximum aggregate Memory limit for the namespace (e.g., '2Gi', '512Mi')."
  default     = "2Gi"
}

variable "max_pods" {
  type        = string
  description = "Maximum number of pods allowed in the namespace."
  default     = "10"
}

variable "labels" {
  type        = map(string)
  description = "Additional tags/labels to apply to tenant resources."
  default     = {}
}
