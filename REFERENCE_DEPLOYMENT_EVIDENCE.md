# Reference Deployment Evidence

This document provides evidence of a reference deployment of the `prod` environment. It includes an architecture diagram, a summary of the key deployed resources, and a high-level cost estimate to help procurement and engineering teams understand the tangible output of this foundation.

---

## 1. Reference Architecture Diagram

The following diagram illustrates the architecture of the `prod` environment as deployed by this Terraform foundation.

```mermaid
graph TD
    subgraph "AWS Cloud"
        subgraph "VPC (10.2.0.0/16)"
            subgraph "Public Subnet 1 (AZ-a)"
                ALB[Application Load Balancer];
            end
            subgraph "Public Subnet 2 (AZ-b)"
                ALB_Replica[Application Load Balancer];
            end
            subgraph "Private Subnet 1 (AZ-a)"
                ECS1[ECS Fargate Task];
                RDS_P[RDS Primary];
            end
            subgraph "Private Subnet 2 (AZ-b)"
                ECS2[ECS Fargate Task];
                RDS_S[RDS Standby];
            end

            ALB -->|HTTPS (443)| ECS1;
            ALB -->|HTTPS (443)| ECS2;
            ECS1 -->|PostgreSQL (5432)| RDS_P;
            ECS2 -->|PostgreSQL (5432)| RDS_P;
            RDS_P -- "Synchronous Replication" --> RDS_S;
        end

        subgraph "Security"
            WAF[AWS WAF] --> ALB;
            IAM[IAM Roles];
            KMS[KMS Key];
            SecretsManager[Secrets Manager];
        end

        subgraph "Logging & Monitoring"
            CW[CloudWatch Logs];
            FlowLogs[VPC Flow Logs] --> CW;
            ECS1 --> CW;
            ECS2 --> CW;
        end
    end

    User[Internet User] --> WAF;
```

---

## 2. Deployed Resource Inventory (Prod Environment)

A `terraform apply` of the `prod` environment configuration will create the following key resources:

| Resource Category | Resource Type | Name / Description | Purpose |
| :--- | :--- | :--- | :--- |
| **Networking** | `aws_vpc` | `prod-MyWebApp-vpc` | Main isolated network |
| | `aws_subnet` | `prod-MyWebApp-public-subnet-*` (x2) | For public-facing resources (ALB) |
| | `aws_subnet` | `prod-MyWebApp-private-subnet-*` (x2)| For internal resources (ECS, RDS) |
| | `aws_internet_gateway` | `prod-MyWebApp-igw` | Provides internet access for public subnets |
| | `aws_nat_gateway` | `prod-MyWebApp-nat-gw-*` (x2) | Provides outbound internet for private subnets|
| **Compute** | `aws_ecs_cluster` | `prod-MyWebApp-ecs-cluster`| Manages the containerized services |
| | `aws_ecs_service` | `prod-MyWebApp-backend-core-service` | Runs the main application tasks |
| | `aws_ecs_service`| `prod-MyWebApp-backend-integrations...`| Runs the integrations service tasks |
| **Database** | `aws_db_instance` | `prod-MyWebApp-db` | PostgreSQL database (Multi-AZ) |
| **Load Balancing**| `aws_lb` | `prod-MyWebApp-alb` | Distributes incoming traffic |
| | `aws_lb_target_group`| `prod-MyWebApp-tg` / `...-integrations-tg`| Groups of ECS tasks for the ALB |
| **Security** | `aws_kms_key` | `prod-MyWebApp-kms-key` | Encrypts all data at rest |
| | `aws_secretsmanager_secret` | Various (RDS, JWT, etc.) | Securely stores all secrets |
| | `aws_iam_role` | Various (ECS Task, Execution, etc.) | Provides least-privilege permissions |
| | `aws_wafv2_web_acl` | `prod-MyWebApp-waf` | Protects the ALB from web exploits |
| **Logging** | `aws_cloudwatch_log_group`| `/ecs/...`, `/aws/vpc/flowlogs/...` | Centralizes all logs |
| | `aws_s3_bucket` | `prod-MyWebApp-alb-access-logs` | Stores ALB access logs |

---

## 3. Cost Envelope Estimates (Prod Environment)

The following is a **high-level estimate** for the `prod` environment as configured in the reference deployment (`terraform.tfvars`). Costs are based on the `ap-southeast-2` (Sydney) region and are subject to change.

*   **VPC (NAT Gateways):** 2 x ~$35/month = **~$70/month**
*   **RDS (`db.m5.large`, Multi-AZ):** 1 x ~$300/month = **~$300/month**
*   **ECS Fargate (4 vCPU, 8 GB Memory, 2 tasks):** 2 x ~$150/month = **~$300/month**
*   **Application Load Balancer:** 1 x ~$25/month = **~$25/month**
*   **KMS Key:** 1 x $1/month = **~$1/month**
*   **Secrets Manager:** (Cost per secret + API calls) = **~$5/month**
*   **Data Transfer & CloudWatch Logs:** (Varies with usage) = **~$50-100/month**

**Estimated Total Monthly Cost:** **~$750 - $800 USD / month**

**Disclaimer:** This is an estimate for the reference `prod` configuration only. Actual costs will vary based on traffic, data storage, and any customizations made by the Buyer. The `dev` and `uat` environments are configured with smaller instances and will have a significantly lower cost.
