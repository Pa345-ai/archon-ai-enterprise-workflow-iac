# Runbook: Major Upgrade and Migration Guide

This runbook provides a safe, step-by-step procedure for performing major upgrades to the core infrastructure components, such as the Terraform version or the AWS provider version.

---

### Procedure for Upgrading the AWS Provider (e.g., v4.x to v5.x)

*   **Trigger:** A business or technical decision to upgrade to a new major version of the AWS provider to access new features or stay within the support window.
*   **Owner:** Lead Platform Engineer / SRE.
*   **Step-by-Step Actions:**
    1.  **Create an Upgrade Branch:** In Git, create a new feature branch for the upgrade (e.g., `upgrade/aws-provider-v5`).
    2.  **Isolate `dev` Environment:** All initial work must be performed in the `dev` environment.
    3.  **Update Provider Constraint:** In the `versions.tf` file for the `dev` environment, update the `version` constraint for the `hashicorp/aws` provider to the new major version (e.g., `~> 5.0`).
    4.  **Run `terraform init -upgrade`:** This command downloads the new provider and updates the lock file.
    5.  **Review Official Upgrade Guide:** Read the official HashiCorp upgrade guide for the new provider version. Identify any breaking changes that require code modifications.
    6.  **Run `terraform plan`:** Generate a plan and carefully review it for any unexpected changes. A major provider upgrade may plan to replace resources. It is critical to understand *why* these changes are happening.
    7.  **Apply and Test:** If the plan is safe, run `terraform apply`. After the apply is complete, perform a full suite of integration and application tests against the `dev` environment.
*   **Verification Steps:**
    1.  **Verify Plan:** The `terraform plan` must be reviewed and approved by a senior engineer.
    2.  **Verify Application Health:** All application health checks in the `dev` environment must be passing after the upgrade.
    3.  **Verify No State Drift:** After testing, run a final `terraform plan` to ensure no unexpected state drift has occurred. The plan should show "No changes."
    4.  **Promote via Pull Request:** Once verified, create a Pull Request for the upgrade branch. The PR should be reviewed and approved before merging into `main` and being promoted to `uat` and `prod` following the standard deployment process.

---

### Procedure for Upgrading Terraform (e.g., v1.3 to v1.4)

*   **Trigger:** A decision to upgrade the Terraform binary to a new minor or major version.
*   **Owner:** Lead Platform Engineer / SRE.
*   **Step-by-Step Actions:**
    1.  **Update CI/CD Environment:** The new Terraform binary version should first be installed and tested in the CI/CD runners or the local developer environments.
    2.  **Isolate `dev` Environment:** Start the upgrade process with the `dev` environment.
    3.  **Update Version Constraint:** In the `versions.tf` file, update the `required_version` constraint to the new target version.
    4.  **Run `terraform init`:** This will re-initialize the backend and confirm the new version is being used.
    5.  **Run `terraform plan`:** Execute a plan. For a minor version upgrade, this should always result in "No changes."
*   **Verification Steps:**
    1.  **Verify Plan Output:** The plan must show "No changes." Any planned changes indicate a problem and the upgrade should be halted for investigation.
    2.  **Verify State Integrity:** Run `terraform apply` to confirm that no changes are made and the state remains in sync.
    3.  **Promote to Other Environments:** Once verified in `dev`, the version constraint change can be applied to `uat` and `prod`.

---
*This is a controlled document. Any changes must be reviewed and approved via a pull request.*
