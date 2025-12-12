# 🛡️ ARCHON AI: Enterprise AI Workflow Platform (IaC)

This repository contains the **Auditable Infrastructure-as-Code (IaC)** for the **ARCHON AI Workflow Platform**—a secure, multi-cloud ready solution designed to accelerate business-critical AI deployments in highly regulated financial environments.

## 🎯 Our Value Proposition: Governance, Risk Elimination, and Guaranteed Deployment

ARCHON AI provides **full control and a guaranteed path to production** for complex, highly compliant AI/ML workloads, eliminating the security and configuration drift risks associated with months of internal platform engineering efforts.

### Key Security & Compliance Features:

| Feature | Audit Value (Why it matters to CommBank) |
| :--- | :--- |
| **Secure Multi-AZ VPC** | Guaranteed High Availability (HA) and resilience across multiple zones, essential for APRA compliance.  |
| **Zero-Trust Networking** | Strict network segmentation: ECS talks *only* to RDS. The database is completely isolated from the public internet. |
| **Secrets Management** | Uses native AWS Secrets Manager injection via Fargate. **Zero plain-text secrets** are exposed in logs, config files, or Terraform state files (`.tfstate`). |
| **Infrastructure-as-Code** | Full immutability and version control via Terraform, providing a verifiable audit trail for every infrastructure change. |

## 🏗️ Architecture Overview

The platform is deployed to **AWS Fargate/ECS** with PostgreSQL persistence in a dedicated, private Multi-AZ RDS instance.

* **Front End:** Next.js (Containerized application).
* **Back End:** FastAPI/Python (Authentication, AI/API aggregation, and Business Logic).
* **Database:** Multi-AZ PostgreSQL (For state, models, and compliance data).
* **IaC:** HashiCorp Terraform (Ensuring immediate deployment and configuration governance).

## 🚀 Deployment: The 5-Day Guarantee

The entire secure stack is designed for a single-command deployment, enabling your engineering team to move from code clone to a fully secure, production-ready environment in **under 5 days**.

### Prerequisites
* AWS CLI and Credentials
* Terraform CLI
* Docker (for building/pushing application images)

### Getting Started
1.  Initialize Terraform: `terraform init`
2.  Review Plan: `terraform plan`
3.  Apply Changes: `terraform apply -auto-approve`

---
*Created by RuwanpuragePawan and ARCHON AI Systems*# archon-ai-enterprise-workflow-iac
