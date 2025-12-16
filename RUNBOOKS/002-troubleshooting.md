# Runbook: Break-Fix and Troubleshooting

This runbook provides procedures for diagnosing and resolving common operational issues. Each section defines the trigger, owner, diagnostic steps, and verification steps.

---

### Issue 1: ECS Tasks Are Failing to Start

*   **Trigger:** A CloudWatch alarm indicating a low running task count, or a failed deployment alert from the CI/CD pipeline.
*   **Owner:** On-call Application Engineer or SRE.
*   **Step-by-Step Actions (Diagnosis):**
    1.  **Navigate to the ECS Console:** Select the cluster and the service that is failing.
    2.  **Review Service Events:** Look for messages related to health check failures or tasks that are "draining".
    3.  **Inspect Stopped Tasks:** Go to the "Tasks" tab and select a recently stopped task. Examine the "Stopped reason" at the top of the page. This is the most important clue.
        *   **If the reason is health checks:** Proceed to the "Health Check Failures" verification below.
        *   **If the reason is an application exit code:** Proceed to the "Application Crash" verification below.
        *   **If the reason is a permissions error:** Proceed to the "Permissions Issue" verification below.
        *   **If the reason is an image error:** Proceed to the "Image Not Found" verification below.
*   **Verification Steps (Resolution):**
    *   **Health Check Failures:**
        1.  Verify that the application's `/health` endpoint is active and returning a `200 OK` status. You can do this by exec'ing into a running container or checking the application logs.
        2.  Verify that the ECS Task Security Group allows inbound traffic on port `8000` from the ALB Security Group.
        3.  Verify the ALB Target Group's health check settings are correct (port `8000`, path `/health`).
    *   **Application Crash:**
        1.  Check the container logs in CloudWatch for the stopped task. Look for a stack trace or an error message that indicates why the application failed to start.
        2.  Common causes include a missing environment variable, a misconfigured connection string, or a code-level bug.
    *   **Permissions Issue:**
        1.  Check the stopped task's "Stopped reason" for "AccessDeniedException".
        2.  Review the IAM Task Role associated with the task definition.
        3.  Ensure the role has permissions to access the required Secrets Manager secrets and KMS keys.
    *   **Image Not Found:**
        1.  Check the stopped task's "Stopped reason" for "CannotPullContainerError".
        2.  Verify the image URI in the task definition is correct and the image tag exists in ECR.

---

### Issue 2: Application Cannot Connect to the RDS Database

*   **Trigger:** A CloudWatch alarm for a high rate of application errors, or application logs showing "Connection Timeout" or "Authentication Failed".
*   **Owner:** On-call Application Engineer or SRE.
*   **Step-by-Step Actions (Diagnosis):**
    1.  **Check Application Logs:** Confirm the exact error message. Is it a timeout or an authentication failure?
    2.  **Check Security Groups:** This is the most common cause.
        *   Navigate to the VPC Console -> Security Groups.
        *   Find the ECS Task Security Group and the RDS DB Security Group.
    3.  **Check Network ACLs:**
        *   Navigate to the VPC Console -> Network ACLs.
        *   Verify the NACLs associated with the private subnets are not blocking PostgreSQL traffic on port `5432`.
*   **Verification Steps (Resolution):**
    *   **For Connection Timeouts:**
        1.  Ensure the RDS DB Security Group has an **inbound rule** allowing traffic on port `5432` from the ECS Task Security Group ID.
        2.  Ensure the ECS Task Security Group has an **outbound rule** allowing traffic to the RDS DB Security Group ID on port `5432`.
    *   **For Authentication Failures:**
        1.  Navigate to the Secrets Manager console.
        2.  Find the RDS master user secret.
        3.  Compare the credentials in the secret with the expected credentials on the RDS instance.
        4.  If rotation is enabled, check the rotation status. A failed rotation is a common cause of credential mismatch.

---
*This is a controlled document. Any changes must be reviewed and approved via a pull request.*
