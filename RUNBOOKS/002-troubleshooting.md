# Runbook: Break-Fix and Troubleshooting

This runbook provides procedures for diagnosing and resolving common operational issues.

---

### Issue 1: ECS Tasks Are Failing to Start (Status: PENDING -> STOPPED)

**Symptom:** When deploying a new version of the application, the ECS service shows tasks that are starting but then quickly move to a `STOPPED` state.

**Potential Causes & Diagnosis:**

1.  **Incorrect Container Image URI:**
    *   **Diagnosis:** In the ECS service events or the stopped task details, look for an error message like "Image not found" or "Cannot pull container image".
    *   **Resolution:** Verify that the `backend_image_uri` variable in your `terraform.tfvars` file is correct and that the image tag exists in ECR.

2.  **Secrets Manager Permissions Issue:**
    *   **Diagnosis:** In the stopped task details, look for an error message like "AccessDeniedException" when trying to access Secrets Manager.
    *   **Resolution:**
        *   Ensure the ECS Task Role (`ecs_task_core_role` or `ecs_task_integrations_role`) has the correct IAM permissions to access the required secrets.
        *   Verify that the VPC has a Secrets Manager endpoint, and the security groups allow the ECS tasks to communicate with the endpoint on port 443.

3.  **Application Crash on Startup:**
    *   **Diagnosis:** The task may start and then exit immediately. Look at the "stopped reason" in the task details, which might show an exit code. Check the container logs in the CloudWatch Log Group for the service to find application-level error messages or a stack trace.
    *   **Resolution:** Debug the application code based on the logs. The issue is likely a misconfiguration passed to the application or a bug in the startup code.

4.  **Health Check Failures:**
    *   **Diagnosis:** The task runs for a few minutes but is then stopped by the ECS service scheduler. The service events will show that the task "failed ELB health checks".
    *   **Resolution:**
        *   Verify that the application is running on the correct port (8000) and that the `/health` endpoint is returning a `200-399` status code.
        *   Check the ALB Target Group's health check settings in the EC2 console.
        *   Ensure the ECS task's security group allows inbound traffic from the ALB security group on port 8000.

---

### Issue 2: Application Cannot Connect to the RDS Database

**Symptom:** Application logs show "connection timeout" or "authentication failed" errors when trying to connect to the database.

**Potential Causes & Diagnosis:**

1.  **Security Group Misconfiguration:**
    *   **Diagnosis:** This is the most common cause. The ECS task's security group does not allow outbound traffic to the RDS instance's security group on port 5432.
    *   **Resolution:**
        *   Navigate to the Security Groups section of the VPC console.
        *   Select the ECS security group. Check its **outbound** rules.
        *   Select the DB security group. Check its **inbound** rules.
        *   Ensure the DB security group's inbound rule allows traffic on port 5432 from the ECS security group's ID.

2.  **Incorrect Database Credentials:**
    *   **Diagnosis:** The application is receiving an "authentication failed" error.
    *   **Resolution:**
        *   Verify that the secret being fetched from AWS Secrets Manager contains the correct, up-to-date credentials for the database.
        *   If rotation is enabled, a recent rotation may have failed, causing a mismatch between the secret and the database password. Check the status of the rotation Lambda in the Secrets Manager console.

3.  **Incorrect Subnet/Routing:**
    *   **Diagnosis:** The ECS task and the RDS instance are in different subnets that cannot communicate.
    *   **Resolution:**
        *   Verify that both the ECS tasks and the RDS instance are deployed in the **private subnets** of the same VPC.
        *   Check the Network ACLs associated with the private subnets to ensure they are not blocking traffic on port 5432. The default NACL allows all traffic.
