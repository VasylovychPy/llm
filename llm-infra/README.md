#  LLM Infrastructure on AWS (Terraform + ASG + Ollama)

##  Overview

This project demonstrates a production-like AWS infrastructure for running a local LLM using **Ollama** inside an **Auto Scaling Group (ASG)** behind an **Application Load Balancer (ALB)**.

The infrastructure is fully managed via **Terraform** and follows DevOps best practices:

* Infrastructure as Code (IaC)
* Layered architecture
* Auto scaling
* Private networking
* Secure access

---

##  Architecture

The infrastructure includes:

* **VPC**

  * Public and private subnets across multiple AZs
* **Application Load Balancer (ALB)**

  * Handles HTTPS traffic
* **Auto Scaling Group (ASG)**

  * Runs EC2 instances in private subnets
* **Launch Template**

  * Installs and configures:

    * Nginx
    * Ollama
    * TinyLlama model
* **Route53 + ACM**

  * Domain and SSL certificate (HTTPS)
* **RDS (PostgreSQL)**

  * Optional database layer
* **Bastion Host / SSM**

  * Secure access to private instances

---

##  Technologies Used

* AWS (EC2, ASG, ALB, VPC, RDS, Route53, ACM)
* Terraform
* Nginx
* Ollama
* TinyLlama (LLM)
* Linux (Amazon Linux 2023)

---

##  What is Ollama?

Ollama is a runtime that allows running LLM models locally on your infrastructure.

In this project:

* Ollama runs on EC2 instances
* Model: `tinyllama`
* API доступна на:

  ```
  http://localhost:11434
  ```

---

##  Deployment

### 1. Clone repository

```bash
git clone https://github.com/VasylovychPy/llm.git
cd application-setup
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply infrastructure

```bash
terraform apply -var-file=workspace_vars/dev-01.tfvars
```

---

## Instance Configuration (User Data)

Each EC2 instance автоматически:

* Installs Nginx
* Installs Ollama
* Starts Ollama service
* Pulls `tinyllama` model

---

## Access

### Application (via ALB)

```bash
https://your-domain.com
```

### Ollama API (inside instance)

```bash
curl http://127.0.0.1:11434/api/tags
```

### Example request

```bash
curl http://127.0.0.1:11434/api/generate -d '{
  "model": "tinyllama",
  "prompt": "What is AWS?",
  "stream": false
}'
```

---

## Security

* EC2 instances are deployed in **private subnets**
* Access only via:

  * Bastion host OR
  * AWS SSM Session Manager
* Security Groups restrict:

  * SSH access
  * ALB → EC2 traffic (port 80)





