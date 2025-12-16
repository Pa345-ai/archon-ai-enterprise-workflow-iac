# 3. ADR: Database High-Availability Model

**Status:** Accepted

**Context:** The database is a critical stateful component of the application. An outage of the database would result in a complete loss of service. The architecture must be resilient to infrastructure failures and support a high level of availability, especially in the production environment.

**Decision:** We have chosen to use Amazon RDS with the Multi-AZ deployment option.

*   **Synchronous Replication:** In a Multi-AZ deployment, RDS automatically provisions and maintains a synchronous standby replica in a different Availability Zone.
*   **Automatic Failover:** If an infrastructure failure is detected on the primary instance, RDS will automatically fail over to the standby replica without manual intervention. The DNS endpoint for the database remains the same, so the application does not need to be reconfigured.
*   **Enhanced Durability:** This model protects against the loss of an entire Availability Zone, a common requirement for disaster recovery and business continuity planning.

**Alternatives Considered:**

1.  **Single-AZ RDS Instance:** A single instance is cheaper but provides no protection against Availability Zone failures. The recovery time objective (RTO) would be significantly higher, as a new instance would need to be provisioned from a snapshot. This is not acceptable for a production environment.
2.  **Self-Managed Database on EC2:** Running a database cluster (e.g., PostgreSQL with streaming replication) on EC2 instances would provide more control over the configuration. However, it would also introduce a significant operational burden for managing the OS, database software, backups, and failover logic. This complexity is not justified when a managed service like RDS provides a robust and reliable solution.
3.  **Amazon Aurora:** Aurora provides even higher availability and performance than standard RDS. However, it comes at a higher price point. For a general-purpose, enterprise-grade baseline, standard RDS Multi-AZ offers the best balance of availability, performance, and cost.

**Consequences:**

*   **Positive:**
    *   **High Availability:** The application can withstand the failure of a single database instance or an entire Availability Zone with minimal downtime.
    *   **Reduced Operational Overhead:** RDS manages the replication and failover process automatically, reducing the burden on the operations team.
    *   **Data Durability:** Synchronous replication ensures that there is no data loss during a failover event.
*   **Negative:**
    *   **Cost:** A Multi-AZ deployment is more expensive than a Single-AZ instance due to the cost of the standby replica.
    *   **Write Latency:** Synchronous replication can introduce a small amount of additional latency for write operations. This is a well-understood trade-off for the increased durability.
