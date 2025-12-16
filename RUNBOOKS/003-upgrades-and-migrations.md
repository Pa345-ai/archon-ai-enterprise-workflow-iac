# Runbook: Major Upgrade and Migration Guide

This runbook provides a safe, step-by-step procedure for performing major upgrades to the core infrastructure components, such as the Terraform version or the AWS provider version.

**Guiding Principles:**

*   **Never Upgrade in Production First:** All upgrades must be tested in a non-production environment (`dev` or `uat`) before being applied to `prod`.
*   **Read the Changelogs:** Before upgrading, always read the official changelogs for the new versions of Terraform and the AWS provider. Pay close attention to any "breaking changes" or "migration guides".
*   **One Major Change at a Time:** Do not upgrade Terraform and the AWS provider in the same release. Upgrade one, test it, and then upgrade the other.
*   **Backup Your State:** Before running any potentially destructive commands, ensure you have a backup of your Terraform state file. S3 state backends with versioning enabled are highly recommended.

---

### Procedure for Upgrading the AWS Provider

**Scenario:** You need to upgrade the AWS provider from version `4.x` to `5.x`.

1.  **Isolate the Environment:** Start with the `dev` environment.
2.  **Update `versions.tf`:**
    *   In the root `versions.tf` of the `dev` environment, update the provider version constraint. For example:
        ```hcl
        # Before
        required_providers {
          aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
          }
        }

        # After
        required_providers {
          aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
          }
        }
        ```
3.  **Run `terraform init -upgrade`:**
    *   This command will download the new provider version and update the `.terraform.lock.hcl` file.
4.  **Review the Upgrade Guide:**
    *   Carefully read the official AWS Provider v5.0 upgrade guide. It will contain details about any deprecated resources or required changes to your code.
5.  **Run `terraform plan`:**
    *   Execute a `terraform plan` and carefully review the output.
    *   Look for any unexpected changes or warnings. The plan should ideally show "No changes" unless the provider upgrade requires modifications to resources. If there are changes, understand exactly why they are happening before proceeding.
6.  **Apply and Test:**
    *   If the plan is safe, run `terraform apply`.
    *   Thoroughly test the `dev` environment to ensure the application is still functioning correctly after the provider upgrade.
7.  **Promote to Other Environments:**
    *   Once you are confident that the upgrade is safe and stable, repeat the process for the `uat` environment, and finally, for the `prod` environment.

---

### Procedure for Upgrading Terraform

**Scenario:** You need to upgrade Terraform from version `1.x` to `1.y`.

1.  **Isolate the Environment:** Start with the `dev` environment.
2.  **Update `versions.tf`:**
    *   In the `versions.tf` file, update the `required_version` constraint.
        ```hcl
        # Before
        terraform {
          required_version = "~> 1.3"
        }

        # After
        terraform {
          required_version = "~> 1.4" # Or your target version
        }
        ```
3.  **Run `terraform init`:**
    *   This will re-initialize the backend and verify the new version constraint.
4.  **Run `terraform plan`:**
    *   Execute a `terraform plan`. The output should be clean and show no changes. A major Terraform version change should not, by itself, cause changes to your infrastructure.
5.  **Apply and Test:**
    *   Run `terraform apply` to confirm that no changes are made and that the state is still in sync.
    *   Perform basic functionality tests on the `dev` environment.
6.  **Promote to Other Environments:**
    *   Once confident, repeat the process for `uat` and `prod`.

**Important:** For upgrades across major versions (e.g., from `0.x` to `1.x`), Terraform provides an `upgrade` command and detailed guides. Always follow the official documentation for these larger migrations.
