# Runbook: Disaster Recovery (DR)

This runbook provides procedures for responding to a disaster scenario, focusing on the failover of the RDS database and the verification of data integrity.

**Scenario:** The primary RDS database instance has become unavailable due to an Availability Zone (AZ) failure.

---

### 1. Verify RDS Automatic Failover

**Objective:** Confirm that the RDS Multi-AZ failover has occurred and the standby replica has been promoted to the new primary.

**Procedure:**

1.  **Navigate to the AWS RDS Console.**
2.  **Select the database instance** for the affected environment.
3.  **Go to the "Logs & events" tab.**
4.  **Look for a recent event** with the description "DB instance failover completed". This event confirms that RDS has automatically handled the failover.
5.  **Check the "Configuration" tab.** Verify that the "Availability zone" of the instance is now different from the original primary AZ.
6.  **Check Application Health:** Monitor the application's health checks. After a brief downtime (typically 1-2 minutes) while the DNS endpoint updates, the application should automatically reconnect to the newly promoted primary and resume normal operation.

**Expected Outcome:** The database is available and serving connections from the new AZ. The application has recovered without manual intervention.

---

### 2. S3 Data Integrity and Restoration (If Necessary)

**Objective:** Ensure that data in S3 buckets (e.g., ALB access logs) is durable and can be restored if needed.

**Context:** S3 is designed for 99.999999999% (11 9's) of durability and automatically stores your data across multiple AZs. Data loss is extremely unlikely. This procedure is for a worst-case scenario where objects are accidentally deleted or corrupted.

**Procedure for Object-Level Recovery (if versioning is enabled):**

1.  **Navigate to the S3 Console.**
2.  **Select the relevant bucket** (e.g., the access logs bucket).
3.  **Use the "List versions" toggle** to view all versions of the objects.
4.  **Find the object and version** you wish to restore.
5.  **Select the previous version** and choose "Actions" -> "Restore".

**Note:** The S3 buckets in this baseline do not have versioning enabled by default to control costs. It is highly recommended to enable versioning on any critical S3 buckets as part of the buyer's standard operating procedures.

---

### 3. Post-Incident Review

**Objective:** Analyze the incident and improve the response process.

**Procedure:**

1.  **Document the timeline** of the incident, from detection to resolution.
2.  **Analyze the root cause.** In this scenario, it was an AZ failure.
3.  **Evaluate the performance** of the automated recovery systems. Was the failover time within the expected range?
4.  **Identify any areas for improvement** in monitoring, alerting, or the runbook itself.
5.  **Update documentation** and share the findings with the team.
