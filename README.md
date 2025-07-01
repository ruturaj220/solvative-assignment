# Solvative DevOps Assignment

This repository contains solutions for a practical DevOps assessment that includes tasks on infrastructure provisioning (Terraform), configuration management (Ansible), system monitoring, MySQL backup scripting, and Docker containerization.

---

## Task 1: Terraform - Infrastructure as Code

### Components Provisioned
- **S3 Buckets**: Static website + media storage
- **IAM Role**: Lambda execution
- **Lambda Function**: Node.js handler
- **API Gateway (HTTP)**: Linked to Lambda
- **DynamoDB Table**: Users
- **Aurora RDS Cluster**: MySQL-based
- **Cognito User Pool**: Authentication service

### Folder: `terraform/`
- Infrastructure files:
  - `main.tf`, `variables.tf`, `outputs.tf`, `provider.tf`
  - Lambda function code: `lambda.zip`

---

## Task 2: Ansible - Configuration Management

### Setup Performed
- Installed and started:
  - Apache2
  - MySQL
  - Docker
- Pulled and ran an NGINX container
  - Mounted ephemeral storage to container volume

### Folder: `ansible/`
- Follows Ansible **role-based structure**
- Inventory: `inventory.ini`
- Entry playbook: `site.yml`
- Roles: `apache`, `mysql`, `docker`, `container`

---

## Task 3: System Monitoring + Backup Scripts

### Scripts Implemented
1. `system_health.sh`:  
   - Reports CPU, memory usage, top processes

2. `mysql_backup.sh`:  
   - Takes a full MySQL DB dump and stores it in `/home/ubuntu/backup`

### Folder: `script/`

---

## 🐳 Task 4: Docker & Containerization

### Setup Performed
- Dockerized a static NGINX web server
- Used Alpine image for lightweight container
- Served content from `index.html`

### Folder: `docker/`
- `Dockerfile`: Builds NGINX container
- `docker-compose.yml`: Spins up container
- `index.html`: Sample landing page

---

## How to Use

### Terraform
```bash
cd terraform
terraform init
terraform apply
# To destroy
terraform destroy
```

```bash
cd ansible
ansible-playbook -i inventory.ini site.yml
```

```bash
cd script
chmod +x *.sh
./system_health.sh
sudo ./mysql_backup.sh
```

```bash
cd docker
docker-compose up --build
docker-compose down
```

### Author
Ruturaj Vaskar
DevOps Engineer 
