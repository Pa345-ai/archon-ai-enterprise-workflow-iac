# 1. ADR: VPC Networking Topology

**Status:** Accepted

**Context:** The application requires a secure and isolated network environment to protect its components from unauthorized access. The networking layer must provide a clear separation between public-facing and internal resources, following the principle of least privilege.

**Decision:** We have chosen to implement a standard public/private subnet topology within the VPC.

*   **Public Subnets:** These subnets have a direct route to an Internet Gateway. Only resources that must be publicly accessible, such as the Application Load Balancer (ALB), are placed here.
*   **Private Subnets:** These subnets do not have a direct route to the internet. All application and database resources, including ECS tasks and the RDS instance, are placed in these subnets. Outbound internet access for tasks like pulling container images is provided through NAT Gateways located in the public subnets.

**Alternatives Considered:**

1.  **All Resources in Public Subnets:** This is the simplest approach but exposes all resources to the public internet, significantly increasing the attack surface. This was rejected as it does not meet baseline security requirements.
2.  **Using a Third-Party Networking Solution:** Solutions like Aviatrix or Cisco CSR could provide more advanced networking features. However, this would introduce additional complexity and cost, and couple the solution to a specific vendor, violating the goal of a vendor-neutral baseline.

**Consequences:**

*   **Positive:**
    *   **Enhanced Security:** The attack surface is minimized by keeping all sensitive resources in private subnets.
    *   **Clear Separation of Concerns:** The network topology is easy to understand and audit.
    *   **Scalability:** This is a standard, well-understood AWS pattern that scales easily.
*   **Negative:**
    *   **Cost:** The use of NAT Gateways incurs additional costs.
    *   **Complexity:** This topology is slightly more complex to set up and manage than a single-subnet design. However, this complexity is justified by the security benefits.
