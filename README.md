# Multi-Tenant Kubernetes GitOps Monorepo

A production-ready Infrastructure-as-Code (IaC) repository demonstrating multi-tenant namespace provisioning, resource guardrails, and automated policy enforcement using **Terraform (HCL)**, **Kubernetes**, and **GitOps CI/CD**.

Designed for platform engineering teams to provide self-service Kubernetes infrastructure to product teams while maintaining strict tenant isolation and security posture.

---

## 📐 Architecture Overview

```text
devops-platform-monorepo/
├── .github/
│   └── workflows/
│       └── terraform-ci.yml       # Automated GitHub Actions CI checks
├── modules/
│   └── k8s-tenant/                # Reusable Terraform Module
│       ├── main.tf                 # Provision NS, ResourceQuota, LimitRange, SA
│       ├── variables.tf            # Configurable tenant parameters
│       └── outputs.tf              # Exported attributes
├── environments/
│   └── dev/
│       └── tenant-payments/        # Dev environment environment state
│           ├── main.tf             # Instantiates k8s-tenant module
│           └── providers.tf        # Kubernetes provider configuration
├── .pre-commit-config.yaml        # Local Git hooks (tflint, trivy, fmt)
└── .tflint.hcl                    # TFLint ruleset configuration

```

---

## 🛡️ Key Platform Features
Tenant Isolation: Automatic setup of dedicated Kubernetes Namespaces and scoped Service Accounts for every tenant squad.

Resource Guardrails: Enforces ResourceQuota (CPU, Memory, Pod limits) to prevent "noisy-neighbor" issues across tenants.

Default Container Limits: Utilizes LimitRange to automatically assign default memory and CPU request/limit profiles to unmanaged tenant pods.

Shift-Left Security: Automated local static checks using pre-commit hooks alongside GitHub Actions workflows.
