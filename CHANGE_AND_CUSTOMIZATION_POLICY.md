# Change and Customization Policy

This document outlines the policy for managing changes, customizations, and upgrades to the Reusable Institutional Cloud Infrastructure Foundation after delivery.

---

## 1. Buyer's Right to Customize

Upon purchase, the Buyer is granted a license to use, modify, and extend the Terraform codebase for their own internal business purposes. The Foundation is designed to be a starting point, and it is expected that the Buyer will customize it to fit their specific needs.

**Key Principles for Customization:**

*   **Maintain Modularity:** When adding new resources, the Buyer should follow the existing modular structure. New infrastructure components should be defined in new, dedicated modules.
*   **Use the `common_tags` Variable:** All new resources should be tagged using the `var.common_tags` variable to ensure consistency.
*   **Update Documentation:** The Buyer is responsible for updating their internal forks of the ADRs, Runbooks, and other documentation to reflect the changes they have made.

---

## 2. Vendor's Change Policy

The Vendor will continue to develop and maintain the core Foundation product. This may include bug fixes, security patches, and new features in subsequent versions.

*   **Release Cycle:** The Vendor will aim to provide minor version updates on a quarterly basis and major version updates on an annual basis.
*   **Backward Compatibility:** Minor versions (e.g., v1.1 to v1.2) will be backward-compatible with the existing module interfaces. Major versions (e.g., v1.x to v2.x) may include breaking changes.
*   **Upgrade Guides:** All major version releases will be accompanied by a detailed upgrade guide, similar to the one in the `RUNBOOKS/` directory.

---

## 3. Merging Upstream Changes

The Buyer is responsible for their own process of merging updates from the Vendor's upstream repository into their customized, internal repository.

**Recommended Process:**

1.  **Use Git:** The Buyer should maintain their customized version of the Foundation in their own Git repository. The Vendor's repository should be configured as a remote (e.g., named `upstream`).
2.  **Fetch and Review:** On a regular basis, the Buyer should fetch the latest changes from the `upstream` remote.
3.  **Merge or Rebase:** The Buyer can then use standard Git strategies (merge or rebase) to incorporate the Vendor's updates into their own codebase.
4.  **Test Thoroughly:** After merging, the Buyer must run a full suite of tests in their non-production environments (`dev` and `uat`) before deploying the updated code to `prod`.

**Disclaimer:** The Vendor is not responsible for resolving merge conflicts or for the outcome of any merge process. The Buyer is solely responsible for the integrity of their internal codebase. Professional services can be engaged to assist with complex upgrades if required.
