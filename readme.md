## 1. Purpose of the Setup

The purpose of this setup is to provision and deploy a **scalable, secure, and production-ready infrastructure on AWS** to run a **Prefect 2.0 Worker** using **ECS Fargate**.

The worker is part of a **work pool** that connects to **Prefect Cloud**, enabling the execution of **data workflows and pipelines** in a serverless container environment.

By leveraging **Infrastructure as Code (IaC)** with **Terraform**, this setup ensures **reproducibility**, **automation**, and easier **management** of the following components:

This infrastructure is fully automated using **Terraform** and **GitHub Actions**, following Infrastructure as Code (IaC) principles and DevOps best practices. The Terraform backend uses **S3 for remote state storage** and **DynamoDB for state locking**, ensuring collaborative and consistent deployment workflows.

---

### Key Components

- **VPC Configuration**  
  A well-structured **Virtual Private Cloud (VPC)** with:
  - Public and private subnets  
  - NAT Gateway  
  - Proper DNS settings

- **ECS Fargate Cluster**  
  Running **containerized Prefect workers** in private subnets with **service discovery** enabled.

- **IAM Roles**  
  Secure IAM roles with **least privilege** access to allow ECS tasks to fetch secrets from **AWS Secrets Manager**.

- **Container Deployment**  
  Deploying the Prefect worker container using the official image:  
  `prefecthq/prefect:2-latest`

- **CI/CD Pipeline**  
  - Automated provisioning with **GitHub Actions**  
  - Terraform format, plan, and apply workflows on push

- **State Management**  
  - Remote backend with **S3**  
  - **DynamoDB** for state locking

- **Prefect Cloud Integration**  
  - Work pool `ecs-work-pool` connected  
  - Centralized orchestration via Prefect UI
---

## Benefits

- Run **data workflows at scale** without managing servers.
- Follows **AWS best practices** and **security standards**.
- Enables **serverless execution** and **auto-scaling** for Prefect workers.
- Promotes **infrastructure reusability** through Terraform.

---

## Technologies Used

- **AWS ECS Fargate**
- **AWS VPC, IAM, Secrets Manager**
- **Terraform**
- **Docker**
- **Prefect 2.0**
- **Prefect Cloud**

---

## 2. Chosen IaC Tool and Rationale

**Tool Chosen:** Terraform

### Why Terraform?

Terraform was selected as the Infrastructure as Code (IaC) tool for this project due to the following reasons:

- **Cloud-Agnostic & Extensible**  
  Supports multiple cloud providers and services, allowing for **scalable and portable infrastructure**.

- **Modular Architecture**  
  Encourages the creation of **reusable and maintainable modules** for key components like VPCs, ECS clusters, and IAM roles.

- **State Management**  
  Maintains a **state file** to track resource states, ensuring **precise planning and predictable deployments**.

- **Strong Community & Ecosystem**  
  Offers a rich ecosystem of modules and **excellent documentation**, making AWS infrastructure provisioning **efficient and reliable**.

- **Declarative Syntax**  
  Enables expressing infrastructure in a **clear, desired-state format**—no need for imperative scripting.

- **First-Class AWS Support**  
  The **Terraform AWS Provider** is mature and actively maintained, supporting all required resources (ECS, IAM, VPC, Secrets Manager, etc.).

Terraform’s **robust features** and powerful **infrastructure lifecycle management** make it the perfect choice for managing the complexity of deploying Prefect Workers on ECS Fargate.

# 3. Step-by-Step Deployment Instructions

Follow these steps to deploy the Prefect Worker infrastructure on AWS using Terraform:

### Option 1: CI/CD via GitHub Actions (Recommended)

step 1. **Fork or Clone this Repo**

   ```bash
   git clone https://github.com/your-username/prefect-ecs-infra.git
   cd prefect-ecs-infra
   ```
step 2. **Set GitHub Secrets**
In your repo's Settings → Secrets and variables → Actions, set the following secrets:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

Any custom TF_VAR_* secrets you’ve added in variables.tf

step 3. **Review GitHub Actions Workflow**
File: .github/workflows/terraform.yml

This workflow runs:

terraform fmt -check

terraform init -backend-config

terraform validate

terraform plan

terraform apply 

step 4. **Push to Trigger Deployment**

```bash
git add .
git commit -m "Trigger deployment"
git push origin main
```
GitHub Actions will handle the rest.

# Option 2: Manual Deployment (Local Machine)

## Step 1. Downloading the required files 

Start by Downloading the files required:

```bash
git clone https://github.com/your-username/prefect-ecs-infra.git
cd prefect-ecs-infra
```

## Step 2. Configure AWS Credentials

Ensure your AWS credentials are available to Terraform. You can configure them using the AWS CLI 

### Using AWS CLI

Run the following command to configure your AWS credentials

```bash
aws configure
```

give your AWS user credentials here

## step 3. Initialize Terraform
Initialize Terraform to download the required providers and modules:

```bash
terraform init
```

## step 4. Review the Execution Plan

Before applying the changes, review the Terraform execution plan to see which resources will be created:

```bash
terraform plan
```

Ensure that all resources are listed as expected. Review the output carefully before proceeding.

## step 5. Apply the Configuration
Deploy the infrastructure by applying the Terraform configuration:

```bash
terraform apply
```
You will be prompted to type yes to approve the deployment. Confirm by typing yes and pressing enter.

## step 6. Retrieve Outputs
After the deployment completes successfully, Terraform will output key information such as the ECS Cluster ARN:

```bash
terraform output
```

Take note of these output values for verification and usage in Prefect Cloud.

## step 7.Verify in Prefect Cloud
Log in to Prefect Cloud at https://app.prefect.cloud/.

Navigate to the Work Pools section.

You should see a work pool named ecs-work-pool associated with your deployed ECS worker.

Confirm that your worker is online and ready to execute Prefect flows.

---

# 4. Verification Steps

After deploying the infrastructure with **Terraform**, follow these steps to verify that everything is working correctly:

---

## Step 1. Verify ECS Cluster and Service

- Log in to the **AWS Management Console** and navigate to the **ECS service**.
- Under **Clusters**, verify that the cluster named `prefect-cluster` has been created.
- Check the **ECS Services** tab within the cluster to ensure that the ECS service for your Prefect worker is **running** and **stable**.

---

## Step 2. Check Subnet Configuration

- Navigate to the **VPC service** in the **AWS Console**.
- Confirm that **three public subnets** and **three private subnets** have been provisioned across different availability zones.
- Ensure that **DNS hostnames** are enabled for the VPC and that a **NAT Gateway** has been created for outbound traffic from private subnets.

---

## Step 3. Confirm IAM Roles and Policies

- In the **IAM Console**, go to **Roles** and confirm that the following roles have been created:
  - `prefect-task-execution-role` with the **AmazonECSTaskExecutionRolePolicy** and custom **Secrets Manager** policy.
- Under **Policies**, confirm that the **SecretsManagerReadPolicy** policy has been created, allowing ECS tasks to read from **AWS Secrets Manager**.

---

## Step 4. Check Prefect Worker in ECS

- Go to the **ECS Console** and navigate to **Task Definitions**.
- Verify that the `prefect-worker` task definition exists.
- Ensure the task definition is configured to use the **prefecthq/prefect:2-latest** Docker image.
- In the **Services** tab of your cluster, check that the ECS **Fargate task** (worker) is running under private subnets with the `prefect-task-execution-role`.

---

## Step 5. Verify Prefect Cloud Integration

- Log in to **Prefect Cloud** and navigate to **Work Pools**.
- You should see the work pool named `ecs-work-pool`.
- Verify that the worker is **successfully registered** and **online**. The worker will automatically start executing flows when they are added to the work pool.

---

 After these checks, you should have a fully functional **Prefect Worker** running in a **serverless ECS Fargate environment**, integrated with **Prefect Cloud** for orchestration.

---

# 5. Resource Cleanup Instructions

To avoid ongoing charges and keep your AWS environment clean, follow these steps to destroy the resources created by this setup:

## Step 1. Navigate to Your Project Directory

Ensure you are in the root directory where your main.tf, provider.tf, and other Terraform files reside.

```bash
cd path/to/your/terraform/project
```

## Step 2. Destroy All Infrastructure

Run the following Terraform command to destroy all provisioned resources:

```bash
terraform destroy
```

Confirm the prompt when Terraform asks for confirmation.

This command will:

- Delete the ECS cluster and services  
- Remove IAM roles and policies  
- Tear down the VPC, subnets, NAT gateway, and other network components  
- Remove ECS task definitions and service discovery configurations  
- Delete any related security groups and secrets (if included in Terraform)

## Step 3. Clean Up Local Terraform State Files (Optional)

After destroying resources, you can clean up your local working directory if needed:

```bash
rm -rf .terraform terraform.tfstate* .terraform.lock.hcl
```

## Step 4. Confirm Cleanup in AWS Console

Double-check the following in the AWS Console:

- No remaining ECS clusters or services  
- No NAT Gateways (to avoid charges)  
- No VPC or subnets tagged with Name=prefect-ecs  
- No custom IAM roles or policies named prefect-task-execution-role, etc.  
- All Secrets Manager secrets (if created manually) are deleted
