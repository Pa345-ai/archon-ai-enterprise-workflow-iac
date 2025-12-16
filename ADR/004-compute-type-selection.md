# 4. ADR: Compute Type Selection

**Status:** Accepted

**Context:** The application's backend services need to be deployed as containers. We need to choose a compute platform that is secure, scalable, and minimizes operational overhead, allowing the buyer's team to focus on their application code, not managing infrastructure.

**Decision:** We have chosen to use AWS Fargate as the compute engine for our Amazon ECS services.

*   **Serverless Container Execution:** Fargate is a serverless, pay-as-you-go compute engine that lets you run containers without managing servers or clusters of Amazon EC2 instances.
*   **Reduced Operational Burden:** With Fargate, there is no need to provision, patch, or scale virtual machines. AWS handles all the underlying infrastructure management.
*   **Enhanced Security:** Fargate provides strong isolation between tasks by design, as each task runs in its own dedicated kernel environment. This improves the security posture compared to running multiple containers on a single EC2 instance.
*   **Seamless Scaling:** Fargate integrates with ECS Service Auto Scaling to automatically scale the number of tasks up or down based on load, without the need to manage the underlying EC2 capacity.

**Alternatives Considered:**

1.  **Amazon ECS on EC2:** This is the traditional model for running ECS, where you manage a cluster of EC2 instances as capacity for your containers. While it offers more control over the environment (e.g., choice of instance types, custom AMIs), it also introduces significant operational overhead for managing the EC2 fleet (patching, scaling, security hardening).
2.  **Amazon Elastic Kubernetes Service (EKS):** EKS is a managed Kubernetes service. While Kubernetes is a powerful and popular orchestrator, it has a steeper learning curve and is generally more complex to manage than ECS. For a baseline product that aims for simplicity and ease of operation, ECS with Fargate is a more appropriate choice.
3.  **AWS Lambda:** For some of the backend services, a Lambda-based, function-as-a-service model could be viable. However, the current application is designed as a long-running service, which is a better fit for a container-based model like ECS.

**Consequences:**

*   **Positive:**
    *   **Lower Operational Overhead:** The buyer's team does not need to manage EC2 instances, freeing up resources to focus on the application.
    *   **Improved Security:** The task-level isolation in Fargate reduces the potential blast radius of a security vulnerability.
    *   **Simplified Scaling:** Auto-scaling is more straightforward as it only involves adjusting the number of tasks, not the underlying EC2 cluster.
*   **Negative:**
    *   **Cost:** For sustained, high-utilization workloads, Fargate can be more expensive than running the equivalent capacity on a well-managed EC2 cluster.
    *   **Less Control:** There is less control over the underlying execution environment compared to the EC2 launch type. This can be a limitation for applications with specific OS-level requirements.
