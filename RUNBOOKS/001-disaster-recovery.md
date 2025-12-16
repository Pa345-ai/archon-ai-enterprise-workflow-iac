# Runbook: Disaster Recovery (DR)

This runbook provides procedures for responding to a disaster scenario, focusing on the failover of the RDS database.

**Scenario:** The primary RDS database instance has become unavailable due to an Availability Zone (AZ) failure.

---

### 1. RDS Multi-AZ Failover

*   **Trigger:** An AWS alarm indicating the primary RDS instance is unreachable, or a major AZ-wide service disruption reported on the AWS Health Dashboard.
*   **Owner:** This process is **fully automated by AWS**. The on-call engineer's role is to monitor and verify the process, not to initiate it.
*   **Step-by-Step Actions:**
    1.  **Monitor AWS Health Dashboard:** Keep track of the official status of the AWS services in the affected region.
    2.  **Monitor Application Metrics:** Observe application health checks and error rates. Expect a brief period of database connection errors.
    3.  **Await Automated Failover:** No manual intervention is required. RDS will automatically detect the failure and promote the standby replica. This process typically takes 1-2 minutes.
*   **Verification Steps:**
    1.  **Verify RDS Event:** Navigate to the AWS RDS Console -> Select the database -> "Logs & events" tab. Confirm that a "DB instance failover completed" event has been logged.
    2.  **Verify New AZ:** On the "Configuration" tab, confirm that the "Availability zone" of the instance has changed.
    3.  **Verify Application Recovery:** Check the application's health endpoint. The application should recover automatically as the database DNS endpoint resolves to the new primary instance.
    4.  **Verify Connectivity:** Manually test the application's core functionality to ensure database connectivity is fully restored.

---

### 2. Post-Incident Review

*   **Trigger:** The resolution of any disaster recovery incident.
*   **Owner:** Lead Operations Engineer / Site Reliability Engineer (SRE).
*   **Step-by-Step Actions:**
    1.  **Convene Post-Mortem:** Schedule a meeting with all relevant engineering and operations teams.
    2.  **Document Timeline:** Create a detailed timeline of the incident, from initial alert to full resolution.
    3.  **Analyze Root Cause:** Identify the specific cause of the failure (e.g., AWS hardware failure, network issue).
    4.  **Assess Impact:** Quantify the impact on the application and business operations (e.g., duration of downtime, number of failed transactions).
    5.  **Identify Action Items:** Define concrete steps to improve monitoring, alerting, or the architecture to reduce the likelihood or impact of future incidents.
*   **Verification Steps:**
    1.  **Verify Post-Mortem Document:** Ensure a post-mortem document is created and shared with all stakeholders.
    2.  **Verify Action Item Tracking:** Ensure all identified action items are entered into a tracking system (e.g., Jira, Asana) and assigned to an owner.

---
*This is a controlled document. Any changes must be reviewed and approved via a pull request.*
