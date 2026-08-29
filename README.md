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
│       └── tenant-payments/        # Dev environment state
│           ├── main.tf             # Instantiates k8s-tenant module
│           └── providers.tf        # Kubernetes provider configuration
├── .pre-commit-config.yaml        # Local Git hooks (tflint, trivy, fmt)
└── .tflint.hcl                    # TFLint ruleset configuration
```

---

## 🛡️ Key Platform Features

* **Tenant Isolation:** Automatic setup of dedicated Kubernetes Namespaces and scoped Service Accounts for every tenant squad.
* **Resource Guardrails:** Enforces `ResourceQuota` (CPU, Memory, Pod limits) to prevent "noisy-neighbor" issues across tenants.
* **Default Container Limits:** Utilizes `LimitRange` to automatically assign default memory and CPU request/limit profiles to unmanaged tenant pods.
* **Shift-Left Security:** Automated local static checks using `pre-commit` hooks alongside GitHub Actions workflows.

---

## 🛠️ Tech Stack & Tooling

| Tool | Purpose |
| :--- | :--- |
| **Terraform (>= 1.5)** | Infrastructure-as-Code engine for declarative configuration. |
| **Kubernetes / Kind** | Orchestration layer (local multi-node development via `Kind` & `OrbStack`). |
| **TFLint** | Static analysis linter for Terraform HCL syntax and best practices. |
| **Trivy** | Security scanner for IaC misconfiguration detection. |
| **Pre-Commit** | Automated git hook execution framework for local verification. |
| **GitHub Actions** | Automated CI pipeline executing validation, linting, and security checks on PRs. |

---

## 🚀 Local Quickstart Guide

### Prerequisites
Ensure the following CLI tools are installed on your workstation:
* [Homebrew](https://brew.sh)
* [OrbStack](https://orbstack.dev) or Docker Desktop
* `terraform`, `kind`, `kubectl`, `tflint`, `trivy`, `pre-commit`

```bash
brew install hashicorp/tap/terraform terraform-linters/tap/tflint trivy kind kubectl pre-commit
```

### 1. Spin Up Local Cluster
Bootstrap a local `kind` cluster:

```bash
kind create cluster --name devops-lab
```

### 2. Configure Pre-Commit Hooks
Enable local automated quality checks prior to committing changes:

```bash
pre-commit install
```

### 3. Deploy a Tenant via Terraform

Navigate to the target environment directory:

```bash
cd environments/dev/tenant-payments

# Initialize providers
terraform init

# Review proposed infrastructure changes
terraform plan

# Provision resources to local cluster
terraform apply -auto-approve
```

### 4. Verify Kubernetes Resources

Check that the namespace, quotas, and service accounts were successfully provisioned:

```bash
kubectl get ns
kubectl get resourcequotas -n dev-payments
kubectl get limitrange -n dev-payments
```

---

## 🤖 CI/CD Pipeline

On every Pull Request to `main`, GitHub Actions automatically triggers the following pipeline:

1. **`terraform fmt -check`** – Code formatting compliance.
2. **`terraform validate`** – HCL syntax validation.
3. **`tflint`** – Static code analysis against recommended rulesets.
4. **`trivy config`** – Static security scanning for IaC misconfigurations.
