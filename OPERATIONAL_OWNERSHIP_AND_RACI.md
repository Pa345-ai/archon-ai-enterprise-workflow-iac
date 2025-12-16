# Operational Ownership and RACI Model

This document defines the roles and responsibilities associated with the Reusable Institutional Cloud Infrastructure Foundation. It establishes a clear RACI (Responsible, Accountable, Consulted, Informed) model to delineate the boundaries between the Vendor (the provider of this foundation) and the Buyer (the organization deploying and using the foundation).

---

## 1. Definitions

*   **Vendor:** The organization that developed and licensed this infrastructure foundation.
*   **Buyer:** The organization that has purchased a license to use this foundation.
*   **Foundation:** The Terraform codebase, documentation, and all associated artifacts included in the product.
*   **Application:** The specific software, business logic, and data that the Buyer deploys on top of the Foundation.

---

## 2. RACI Matrix

| Task / Responsibility | Vendor | Buyer's Platform/Cloud Team | Buyer's Application Team |
| :--- | :---: | :---: | :---: |
| **1. Foundation Code Management** | | | |
| Maintaining the core Terraform modules | R, A | C | I |
| Upgrading the Foundation to new major versions | R, A | C | I |
| Bug fixes within the Foundation code | R, A | C | I |
| **2. Buyer's Deployment** | | | |
| Deploying the Foundation to Buyer's AWS accounts | I | R, A | I |
| Managing Terraform state and CI/CD pipelines | I | R, A | C |
| Customizing or extending the Foundation modules | I | R, A | C |
| AWS account costs and billing | I | R, A | I |
| **3. Application Management** | | | |
| Developing and testing the Application | I | C | R, A |
| Deploying new versions of the Application | I | C | R, A |
| Monitoring Application performance and errors | I | I | R, A |
| Managing Application-level data | I | I | R, A |
| **4. Security & Compliance** | | | |
| Security of the baseline Foundation architecture | R, A | C | I |
| Security of the Buyer's AWS accounts | I | R, A | C |
| Security of the Application code and data | I | C | R, A |
| Auditing and proving compliance to Buyer's regulators | I | R, A | C |
| **5. Operations & Incident Response** | | | |
| Responding to AWS service outages | I | R, A | I |
| Responding to Application-level incidents | I | C | R, A |
| Responding to Foundation-level incidents (e.g., a bug in a module) | C | R, A | I |
| Executing operational runbooks (DR, upgrades, etc.) | I | R, A | C |

---

## 3. Escalation Boundaries and Support

*   **Vendor Guarantees:** The Vendor guarantees that the Foundation code is free from defects at the time of delivery and is compatible with the versions specified in the `PRODUCT_SCOPE_AND_GUARANTEES.md` document.
*   **Buyer Owns Post-Delivery:** Once the Foundation is delivered, the Buyer owns its deployment, operation, and any customizations made to it. The Buyer's Platform/Cloud Team is **Accountable** for the ongoing management of the infrastructure.
*   **Support Assumptions:**
    *   This product is licensed "as-is" and does not include a Service Level Agreement (SLA) or ongoing operational support.
    *   The Vendor can be engaged for support, customization, or managed services through a separate Professional Services or Managed Services agreement.
*   **Escalation Path:**
    1.  **Application Issue:** The Buyer's Application Team is the first responder.
    2.  **Infrastructure Issue:** If the issue is suspected to be with the underlying infrastructure, the Buyer's Platform/Cloud Team takes ownership.
    3.  **Foundation Code Bug:** If the Platform Team isolates the issue to a bug within the original Foundation code, they should report it to the Vendor. The Vendor will be **Responsible** for providing a patch or fix in a subsequent release, but is not responsible for the immediate incident response.

This clear delineation of responsibilities is mandatory for successful long-term operation and allows the Buyer's procurement and risk teams to understand the exact nature of the product they are purchasing.
