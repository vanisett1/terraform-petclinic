

# PetClinic Infrastructure Setup with Terraform

This project provides an automated infrastructure setup for running the PetClinic application on AWS using Terraform. It provisions networking, an Auto Scaling Group (ASG), an Application Load Balancer (ALB), an Amazon RDS instance, and integrates Cloudflare for DNS management and SSL termination.

## Project Overview

### Key Components:
1. **VPC Setup**:
   - Three-tier subnet architecture:
     - **Public Subnets**: Routes traffic to the Internet Gateway.
     - **Private Subnets**: Routes traffic via the NAT Gateway.
     - **Secure Subnets**: No direct internet access.

2. **Application Load Balancer (ALB)**:
   - Deployed in public subnets with listeners and target groups configured to forward traffic to EC2 instances.

3. **Auto Scaling Group (ASG)**:
   - EC2 instances deployed in private subnets, automatically scaling based on application load, and connected to the ALB.

4. **RDS (Amazon Aurora)**:
   - A secure, managed relational database (Amazon Aurora) hosted in the secure subnets.

5. **Cloudflare Integration**:
   - DNS management, SSL certificates, and secure access provided by Cloudflare.

6. **CloudWatch Logs**:
   - Application and Docker logs are streamed to CloudWatch for monitoring.

---

## Architecture

### VPC Subnets
- **Public Subnets**: Hosts the ALB and has internet access.
- **Private Subnets**: Hosts the EC2 instances behind the NAT Gateway.
- **Secure Subnets**: Hosts the RDS instance with no internet access.

### Security Overview
- **No public IPs** for EC2 instances.
- **SSM and EC2 Instance Connect** used for access (no port 22 for SSH).
- **Security Groups** are configured for least privilege, allowing only necessary traffic.

---

## Prerequisites

- **AWS CLI** installed and configured.
- **Terraform** version 0.14+ installed.
- **Cloudflare Account** with an API token for managing DNS and SSL.
- **Docker** installed for local development (optional).

---

## Deployment Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/terraform-petclinic.git
   cd terraform-petclinic/environments/dev
   ```

2. **Initialize Terraform**:
   Initialize the Terraform configuration and download necessary providers:
   ```bash
   terraform init
   ```

3. **Apply Infrastructure**:
   Apply the Terraform configuration to provision the infrastructure. Enter necessary values such as `db_password` and `cloudflare_api_token`:
   ```bash
   terraform apply
   ```

4. **Access the Application**:
   After deployment, the PetClinic application will be accessible at the Cloudflare-managed domain (e.g., `https://petclinic-dev.agklya.com`).

---

## Project Structure

```bash
.
├── .github/workflows/                 # GitHub Actions workflow for CI/CD automation
│   └── terraform.yml                  # Terraform GitHub Action workflow
├── environments/dev/
│   ├── main.tf                        # Main Terraform configuration for the dev environment
│   ├── backend.tf                     # Remote backend configuration for state storage
│   ├── terraform.tfvars               # Input variables for the dev environment
│   ├── variables.tf                   # Variable definitions
├── modules/
│   ├── alb/                           # ALB module
│   ├── asg/                           # ASG module
│   ├── cloudflare/                    # Cloudflare module for DNS management
│   ├── rds/                           # RDS (Aurora) module
│   └── vpc/                           # VPC, subnets, and networking configuration
└── .gitignore                         # Ignore file for git
```

---

## Variables

Key variables can be provided through `terraform.tfvars` or entered during `terraform apply`:

```hcl
db_password          = "your_rds_db_password"
cloudflare_api_token = "your_cloudflare_api_token"
```

---

## Logging and Monitoring

- **CloudWatch Logs** is used to stream application and Docker logs.
- **Amazon CloudWatch Agent** is configured on EC2 instances to collect log data.

---

## RTO and RPO

- **Recovery Time Objective (RTO)**: The use of ASG ensures quick recovery, targeting under 5 minutes to replace failed instances.
- **Recovery Point Objective (RPO)**: With frequent RDS snapshots and backups, RPO is minimal (near-zero).

---

## Future Enhancements

- Extend monitoring with additional metrics.
- Implement cost-saving strategies using spot instances.
- Enhance security with further IAM policy restrictions.

