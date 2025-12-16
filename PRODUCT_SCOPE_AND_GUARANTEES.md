# Product Scope and Guarantees

This document defines the scope, guarantees, and exclusions for the Reusable Institutional Cloud Infrastructure Foundation. It is intended to provide clarity for architecture, procurement, and legal teams.

---

## 1. Included in Purchase

The one-time license fee provides the buyer with the following assets and guarantees:

### 1.1. Terraform Infrastructure as Code (IaC)
*   A complete, modular Terraform codebase for deploying a multi-environment (dev, uat, prod) baseline architecture on AWS.
*   The codebase is designed for reusability, allowing the buyer to customize and extend the foundation for their specific applications.

### 1.2. Security-Hardened Baseline Architecture
*   A production-ready architecture that follows AWS Well-Architected Framework principles for security, reliability, and operational excellence.
*   Includes network isolation (public/private subnets), encryption at rest and in transit, least-privilege IAM roles, and a web application firewall (WAF).

### 1.3. Policy-as-Code Enforcement
*   A pre-configured `tfsec` policy file (`tfsec.yml`) that enforces security best practices via static analysis.
*   Documentation on how to integrate these checks into a CI/CD pipeline to prevent non-compliant infrastructure from being deployed.

### 1.4. Reference Deployment Configuration
*   Example Terraform variable files (`.tfvars`) for each environment, demonstrating how to configure and deploy the infrastructure.

### 1.5. Compliance & Audit Documentation
*   A `COMPLIANCE_MATRIX.md` file mapping the architecture to common controls from CIS, SOC 2, and ISO 27001.
*   An `ENVIRONMENT_ISOLATION_MODEL.md` and `IDENTITY_AND_ACCESS_MODEL.md` to satisfy audit and risk reviews.

### 1.6. Operational Documentation
*   A full suite of Architecture Decision Records (ADRs) explaining the "why" behind key design choices.
*   Executable, auditable runbooks for Disaster Recovery, Troubleshooting, and Upgrades.
*   A clear RACI matrix (`OPERATIONAL_OWNERSHIP_AND_RACI.md`) to define post-delivery responsibilities.

---

## 2. Explicitly Excluded

This product is an infrastructure foundation, not a managed service or a complete application. The following are explicitly excluded from the scope of delivery:

*   **Application Code:** The buyer is responsible for developing and deploying their own application code on top of this infrastructure.
*   **Business Logic:** The baseline does not contain any business-specific logic or workflows.
*   **Customer-Specific Regulatory Interpretations:** While the foundation aligns with common compliance frameworks, the buyer is responsible for ensuring it meets their specific regulatory and legal obligations.
*   **Ongoing Managed Operations:** The purchase does not include ongoing monitoring, management, or support. A separate Managed Services or Support contract can be negotiated if required.
*   **AWS Account Costs:** The buyer is responsible for all costs incurred on their AWS account from the deployment of these resources.

---

## 3. Compatibility Guarantees

This product is guaranteed to be compatible with the following tool versions:

*   **Terraform Version:** `~> 1.3`
*   **AWS Provider Version:** `~> 5.0`
*   **Supported AWS Regions:** All commercial AWS regions that support all required services (VPC, ECS, Fargate, RDS, KMS, WAF, S3, Secrets Manager).

### 3.1. Upgrade and Backward-Compatibility Policy
*   This product follows a semantic versioning model. Minor version updates will be backward-compatible.
*   Major version updates may introduce breaking changes. A detailed upgrade guide will be provided with each major release, similar to the one included in the `RUNBOOKS/` directory.

---

## 4. Code Quality Guarantees

*   **`terraform validate` Pass Guarantee:** The code is guaranteed to pass `terraform validate` in all environments, ensuring syntactic correctness and internal consistency.
*   **`terraform plan` Reproducibility:** The codebase is designed to produce deterministic plans. No non-deterministic data sources or configurations are used that would cause the plan to change on subsequent runs without any code changes.
*   **Zero Deprecated Syntax:** The code is written using modern Terraform HCL syntax and does not rely on any deprecated resources or attributes at the time of delivery.
*   **Strict Module Boundaries:** Each module has a clearly defined responsibility and interface, promoting reusability and maintainability.
