# Compliance Matrix

This document maps the infrastructure configurations in this repository to common security and compliance frameworks. It is intended to provide a high-level overview for compliance officers and security teams to accelerate their review process.

**Note:** This is not an exhaustive list of all controls but highlights the key architectural decisions and configurations that address common requirements. The buyer is responsible for performing their own independent audit and validation.

---

## CIS AWS Foundations Benchmark (Level 1)

| CIS Control ID | Description | Terraform Resource(s) & Configuration |
| :--- | :--- | :--- |
| **1.1** | Avoid the use of the 'root' account | **IAM Module:** No resources use the root account. All actions are performed via IAM roles. |
| **1.16** | Ensure IAM policies are attached only to groups or roles | **IAM Module:** All IAM policies are attached to IAM roles (`aws_iam_role_policy_attachment`), not users. |
| **2.1** | Ensure CloudTrail is enabled in all regions | **Logging Module (Future Enhancement):** While not explicitly configured, this is a recommended addition. The current logging module focuses on application and VPC logs. |
| **2.2** | Ensure CloudTrail log file validation is enabled | **Logging Module (Future Enhancement):** Recommended addition for CloudTrail configurations. |
| **2.4** | Ensure CloudTrail trails are integrated with CloudWatch Logs | **Logging Module (Future Enhancement):** Recommended addition for CloudTrail configurations. |
| **2.8** | Ensure rotation for customer-created KMS keys is enabled | **KMS Module:** The `aws_kms_key` resource has `enable_key_rotation` set to `true`. |
| **3.1** | Ensure VPC flow logging is enabled in all VPCs | **Logging Module:** The `aws_flow_log` resource is configured to capture all traffic (`ALL`) for the VPC and send it to a dedicated CloudWatch Log Group. |
| **4.1/4.2** | Ensure no security groups allow unrestricted ingress to ports 22/3389 | **Security Module:** The `aws_security_group` resources are configured with specific ingress rules and do not allow unrestricted access to sensitive ports. |
| **4.3** | Ensure no security groups allow unrestricted ingress from 0.0.0.0/0 to any port | **Security Module:** The ALB security group restricts ingress to specific CIDR blocks defined by the `allowed_ingress_cidrs` variable. |

---

## SOC 2 (Security, Availability, Confidentiality)

| SOC 2 Trust Service Criteria | Description | Terraform Resource(s) & Configuration |
| :--- | :--- | :--- |
| **CC6.1** | Logical and Physical Access Controls | **IAM & Security Modules:** Access is restricted by principle of least privilege. IAM roles grant specific permissions, and security groups limit network access between components. |
| **CC6.6** | Information and System Protection | **VPC, KMS, RDS, S3 Modules:** All data is encrypted at rest using KMS. The VPC isolates resources from the public internet. Secrets are managed in AWS Secrets Manager. |
| **CC7.1** | System Monitoring | **Logging & ECS Modules:** ECS services are configured to send logs to CloudWatch. VPC Flow Logs are enabled. Container Insights are enabled on the ECS cluster for performance monitoring. |
| **A1.1** | System Availability | **RDS & ECS Modules:** The RDS database is deployed in a Multi-AZ configuration for high availability. ECS services are configured with auto-scaling to handle load changes. |
| **C1.1/C1.2** | Confidentiality of Information | **KMS & Secrets Modules:** All secrets and sensitive data are encrypted using customer-managed KMS keys. Secrets are stored in AWS Secrets Manager and automatically rotated. |

---

## ISO 27001:2013

| ISO 27001 Control | Description | Terraform Resource(s) & Configuration |
| :--- | :--- | :--- |
| **A.9.1.2** | Access to networks and network services | **VPC & Security Modules:** Resources are deployed in private subnets with no direct internet access. Security groups and network ACLs control the flow of traffic between subnets and services. |
| **A.10.1.1** | Policy on the use of cryptographic controls | **KMS, RDS, S3 Modules:** All data at rest is encrypted by default using AWS KMS. The ALB enforces modern TLS policies (TLS 1.2+) for data in transit. |
| **A.12.1.2** | Protection against malware | **WAF Module:** The `aws_wafv2_web_acl` is associated with the ALB and uses AWS Managed Rules to protect against common web exploits, including those that may deliver malware. |
| **A.12.4.1** | Event logging | **Logging Module:** Centralized logging is implemented using CloudWatch Logs for ECS application logs and VPC flow logs. |
| **A.14.2.1** | Secure development policy | **IAM & Secrets Modules:** Secrets are not hard-coded in the application or Terraform state. They are fetched at runtime from AWS Secrets Manager, following secure development best practices. |
| **A.17.1.1** | Information security continuity planning | **RDS Module:** The database is configured for Multi-AZ deployment, which provides a key part of a disaster recovery and business continuity plan. Regular automated backups are enabled. |
