# Compliance Evidence Model

This document describes the model for generating machine-verifiable evidence to prove that the deployed infrastructure complies with the controls defined in the `COMPLIANCE_MATRIX.md`. This transforms our compliance posture from aspirational to provable and auditable.

---

## 1. From Controls to Evidence

The core of this model is the mapping of abstract compliance controls to concrete evidence that can be automatically generated. The flow is as follows:

1.  **Compliance Control:** An abstract requirement from a framework (e.g., "ISO 27001: A.10.1.1 - Encrypt all data at rest").
2.  **Terraform Resource Configuration:** A specific configuration in the Terraform code that implements the control (e.g., the `storage_encrypted = true` attribute on an `aws_db_instance` resource).
3.  **Policy-as-Code Rule:** A `tfsec` custom check (in `tfsec.yml`) that verifies the presence and correct value of that attribute. This provides evidence *before* deployment.
4.  **Live State Evidence:** A script that queries the live AWS environment to confirm that the deployed resource has the expected configuration. This provides evidence *after* deployment.

---

## 2. Evidence Generation Script

To facilitate automated evidence collection, a script is provided in the `/scripts` directory: `generate_compliance_evidence.sh`.

This script uses the AWS CLI to query the live environment and generate a simple report in Markdown format. It is designed to be run by an auditor or a compliance officer with read-only access to the AWS account.

### 2.1. How it Works
*   The script takes the environment name (`dev`, `uat`, or `prod`) as an input.
*   It uses AWS CLI `describe` commands to check the configuration of key resources.
*   It compares the actual configuration against the expected "secure" configuration.
*   It generates a report (`compliance_evidence_report.md`) with a "PASS" or "FAIL" status for each checked control.

### 2.2. Example Evidence Artifacts

An example of the output from the script:

```markdown
# Compliance Evidence Report for Environment: prod

| Control ID | Description | Resource ID | Status |
| :--- | :--- | :--- | :--- |
| **CIS 2.8** | KMS Key Rotation Enabled | `arn:aws:kms:ap-southeast-2:123456789012:key/xxxx-xxxx` | **PASS** |
| **SOC 2 C1.1** | RDS Encryption Enabled | `prod-MyWebApp-db` | **PASS** |
| **ISO A.10.1.1** | S3 Bucket Encryption Enabled | `prod-MyWebApp-alb-access-logs` | **PASS** |
| **CIS 4.3** | No Unrestricted Ingress | `sg-xxxxxxxx` | **PASS** |
```

---

## 3. Audit Trail

Every piece of evidence is backed by a comprehensive audit trail provided by native AWS services:

*   **AWS CloudTrail:** Every `describe` call made by the evidence generation script is logged in CloudTrail. This provides a record of *who* ran the check, *what* they checked, and *when*.
*   **Terraform State:** The Terraform state file in S3 serves as a complete and historically versioned record of the intended state of the infrastructure at any point in time.

This model provides a transparent, automated, and auditable system for proving that the deployed infrastructure meets its compliance obligations.
