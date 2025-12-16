# Risk and Limitations

This document provides a transparent overview of the risks, limitations, and dependencies associated with the Reusable Institutional Cloud Infrastructure Foundation. It is intended to provide a clear and honest assessment for risk, compliance, and legal teams.

---

## 1. Shared Responsibility Model

This product follows the AWS Shared Responsibility Model.
*   **AWS is responsible for the security *of* the cloud:** Protecting the hardware, software, networking, and facilities that run AWS services.
*   **The Vendor is responsible for the security of the *design* of the Foundation:** Ensuring the Terraform code and architecture align with security best practices at the time of delivery.
*   **The Buyer is responsible for the security *in* the cloud:** Managing their AWS accounts, securing their application code, and operating the infrastructure in a secure manner.

**Limitation:** The security of the final deployed environment is ultimately the Buyer's responsibility. A secure foundation can be compromised by insecure application code, overly permissive IAM policies created by the Buyer, or poor operational practices.

---

## 2. Key Dependencies

The successful operation of this Foundation is dependent on several external factors that are outside the Vendor's control:

*   **AWS Service Availability:** The Foundation relies on the availability and correct functioning of the underlying AWS services. An outage or change in an AWS service could impact the infrastructure.
*   **Third-Party Tools:** The security validation pipeline relies on third-party tools like `tfsec`. A change or vulnerability in these tools could affect the security posture.
*   **Buyer's AWS Account Configuration:** The Foundation assumes that the Buyer's AWS accounts are configured with basic security hygiene, including an active AWS CloudTrail for auditing.

**Risk:** The Vendor is not responsible for failures or vulnerabilities that originate from these external dependencies.

---

## 3. Scope of Compliance

*   The `COMPLIANCE_MATRIX.md` provides a mapping of the Foundation's controls to common security frameworks. This mapping is intended to accelerate the Buyer's audit process.
*   **Limitation:** This documentation is **not an attestation of compliance**. The Buyer is solely responsible for achieving and maintaining their own legal and regulatory compliance. The Foundation is a tool to help meet compliance objectives, not a guarantee of compliance itself.

---

## 4. Customization and Configuration

*   This Foundation is designed to be a reusable and customizable baseline.
*   **Risk:** The Buyer is responsible for any changes they make to the original Terraform code. Incorrect modifications could lead to security vulnerabilities, instability, or non-compliance. The Vendor is not responsible for the outcome of any customizations made by the Buyer.

---

## 5. Security of Application Code

*   **Limitation:** The Foundation provides a secure infrastructure on which to run applications. It makes no guarantees about the security of the Buyer's application code. A vulnerability in the Buyer's application (e.g., SQL injection, cross-site scripting) could still lead to a security breach, even on a secure infrastructure.

By purchasing this product, the Buyer acknowledges these risks and limitations and accepts their role in the shared responsibility model.
