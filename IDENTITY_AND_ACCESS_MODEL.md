# Identity and Access Model

This document describes the principles and implementation of the Identity and Access Management (IAM) model for this infrastructure foundation. The design follows the principle of least privilege to ensure a secure and auditable environment.

---

## 1. Core Principles

*   **No IAM Users:** Direct access via IAM users is strongly discouraged. All human access should be managed through a centralized identity provider (e.g., AWS IAM Identity Center) that federates into the AWS accounts using temporary credentials.
*   **Roles for Everything:** Every component, from the ECS tasks to the CI/CD pipeline, interacts with AWS using a specific IAM role with the minimum necessary permissions.
*   **Least Privilege:** IAM policies are tightly scoped. For example, the ECS task role is only granted access to the specific Secrets Manager secrets and KMS keys it requires, not all secrets or keys in the account.
*   **Clear Trust Boundaries:** IAM role trust policies (`AssumeRolePolicy`) are explicitly defined to control *who* or *what* can assume a role. For example, the ECS task roles can only be assumed by the ECS Tasks service (`ecs-tasks.amazonaws.com`).

---

## 2. Key IAM Roles and Rationale

The following are the key IAM roles defined in the `/modules/iam` and `/modules/logging` modules:

### 2.1. `ecs_execution_role`
*   **Purpose:** This role is used by the ECS agent itself, not the application container.
*   **Permissions:** It is granted the AWS-managed `AmazonECSTaskExecutionRolePolicy`, which allows it to pull container images from ECR and send logs to CloudWatch.
*   **Trust Policy:** Trusts the `ecs-tasks.amazonaws.com` service principal.

### 2.2. `ecs_task_core_role`
*   **Purpose:** This is the role assumed by the main application containers (the "core" service). It defines the permissions of the application itself.
*   **Permissions (Example Policy):**
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "secretsmanager:GetSecretValue",
                "Effect": "Allow",
                "Resource": [
                    "arn:aws:secretsmanager:ap-southeast-2:123456789012:secret:prod-MyWebApp-RDSSecret-??????",
                    "arn:aws:secretsmanager:ap-southeast-2:123456789012:secret:prod-MyWebApp-JWTSecret-??????",
                ]
            },
            {
                "Action": "kms:Decrypt",
                "Effect": "Allow",
                "Resource": "arn:aws:kms:ap-southeast-2:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
            }
        ]
    }
    ```
*   **Rationale:** This policy is extremely granular. It only allows access to the specific secrets required by the core application and the specific KMS key needed to decrypt them. This prevents a compromise of the core application from exposing unrelated secrets.

### 2.3. `vpc_flow_logs_role`
*   **Purpose:** This role is used by the VPC Flow Logs service to write log data to CloudWatch Logs.
*   **Permissions:** It is granted the AWS-managed `AmazonVPCFlowLogsRole` policy.
*   **Trust Policy:** Trusts the `vpc-flow-logs.amazonaws.com` service principal.

---

## 3. Bring-Your-Own-Key (BYOK) Model

For many regulated industries, it is a requirement that the customer, not the vendor, owns and manages the cryptographic keys used for encryption. This architecture supports a Bring-Your-Own-Key (BYOK) model for the primary KMS key.

### 3.1. Implementation
The `/modules/kms` module is designed to either:
1.  Create a new customer-managed KMS key if no key is specified.
2.  Use an existing KMS key if the buyer provides the ARN of their own key.

### 3.2. How to Use a BYOK Flow
1.  **Pre-create the KMS Key:** The buyer creates a KMS key in their AWS account with the appropriate key policy. The key policy must, at a minimum, grant usage permissions to the IAM roles that will need to use it (e.g., the ECS task roles).
2.  **Provide the ARN:** The buyer provides the ARN of their existing key as a variable to the root Terraform module.
3.  **Conditional Creation:** The KMS module will detect that a key ARN has been provided and will skip the creation of a new key, instead using the buyer's key for all encryption operations (RDS, S3, Secrets Manager).

This model provides a clear path for customers with strict compliance requirements to integrate this foundation into their existing key management infrastructure.
