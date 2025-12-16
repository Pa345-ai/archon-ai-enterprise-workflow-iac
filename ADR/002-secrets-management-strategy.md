# 2. ADR: Secrets Management Strategy

**Status:** Accepted

**Context:** The application requires access to sensitive information, including database credentials, API keys, and JWT secrets. These secrets must be stored securely, with access tightly controlled and audited. Hard-coding secrets in configuration files or Terraform state is a major security vulnerability and is unacceptable.

**Decision:** We have chosen to use AWS Secrets Manager as the centralized and secure store for all application secrets.

*   **Centralized Storage:** All secrets are stored as `aws_secretsmanager_secret` resources.
*   **Encryption at Rest:** All secrets are encrypted using a customer-managed AWS KMS key.
*   **Automated Rotation:** For secrets that support it (like the RDS master password), automated rotation is enabled to limit the lifespan of any single credential.
*   **Runtime Retrieval:** The ECS tasks are granted specific IAM permissions to retrieve only the secrets they need at runtime. Secrets are not present in the Terraform state or in the container images.

**Alternatives Considered:**

1.  **AWS Systems Manager Parameter Store (SSM):** SSM Parameter Store can also store secrets. However, Secrets Manager provides built-in rotation capabilities and a more focused API for managing the lifecycle of secrets, which is a key requirement for enterprise-grade security.
2.  **HashiCorp Vault:** Vault is a powerful, industry-standard secrets management tool. However, it requires a separate, dedicated infrastructure to be deployed and managed, which would significantly increase the operational overhead and complexity of this baseline solution. AWS Secrets Manager provides a fully managed, native AWS solution that meets all core requirements.
3.  **Environment Variables:** Passing secrets via environment variables to the ECS tasks is a common pattern. However, these variables can be exposed through the AWS console or API, making them less secure than fetching secrets at runtime from a dedicated service.

**Consequences:**

*   **Positive:**
    *   **Strong Security:** Secrets are encrypted, centrally managed, and automatically rotated, adhering to security best practices.
    *   **Auditable:** All access to secrets is logged via CloudTrail, providing a clear audit trail.
    *   **Reduced Operational Overhead:** As a managed service, Secrets Manager handles the underlying infrastructure for storing and managing secrets.
*   **Negative:**
    *   **Cost:** AWS Secrets Manager is a paid service, and costs will scale with the number of secrets and API calls.
    *   **Slightly Increased Complexity:** The application code must include logic to retrieve secrets from the Secrets Manager API at startup.
