# LLM Infrastructure on AWS (Terraform + Terragrunt + Packer + Ansible)

## Overview

This project implements a production-like AWS infrastructure for running LLM services (Ollama) with a complete monitoring and alerting stack.

The infrastructure is built using a **layered Terraform architecture**:

- Infrastructure as Code (Terraform + Terragrunt)
- Layered architecture (account / environment / application)
- Immutable infrastructure (custom AMIs via Packer)
- Configuration management (Ansible)
- Private networking
- Centralized monitoring (Prometheus + Grafana)
- CloudWatch + SNS alerting
- Persistent storage via RDS (PostgreSQL)

---

##  Architecture

### 🔹 Core Flow

```text
Internet → Nginx (HTTPS) → Web Server → ALB → LLM Instances (Ollama)
                               ↓
                              RDS (PostgreSQL)

LLM Instances → Alloy → Prometheus → Grafana
```

---

##  Infrastructure Layers

The project is divided into **three logical layers**:

### 🔹 1. account-setup

Responsible for global account-level infrastructure:

- VPC
- Remote state (S3)

---

### 🔹 2. environment-setup

Defines environment-specific configuration:

- Subnets (public / private)
- NAT Gateway
- Internet Gateway
- Routing configuration

---

### 🔹 3. application-setup

Deploys application components:

- Web Server (Nginx + Open WebUI + Monitoring)
- ASG for LLM instances
- ALB
- RDS (PostgreSQL)
- Bastion Host
- CloudWatch alerts + SNS

---

## AMI Strategy (Packer + Ansible)

The infrastructure uses **custom AMIs** built with Packer and configured via Ansible.

### 🔹 Web AMI

Includes:

- Nginx (HTTPS termination & reverse proxy)
- Prometheus
- Grafana
- Alloy
- Docker

---

### 🔹 LLM AMI

Includes:

- Ollama
- Preloaded model (`llama3.2:3b `)
- Grafana Alloy

---

## AMI Build Process

Custom AMIs must be built before deploying the application layer.

Packer creates immutable images, and Ansible configures them during build time.

### Build Web AMI

```bash
cd llm-automation/packer/monitoring-web
packer init .
packer validate .
packer build .
```

### Build LLM AMI

```bash
cd llm-automation/packer/llm
packer init .
packer validate .
packer build .
```

### Notes

- Web AMI contains full monitoring stack + Nginx
- LLM AMI contains Ollama + metrics agent
- AMI IDs are used later in Terraform / Terragrunt

---

##  Deployment Options

You can deploy infrastructure in two ways:

---

### Option 1: Makefile (Terraform)

Each layer can be deployed independently.

#### 1. Account layer

```bash
cd account-setup
make apply
```

#### 2. Environment layer

```bash
cd environment-setup
make apply
```

#### 3. Application layer

```bash
cd application-setup
make apply
```

---

### 🔹 Option 2: Terragrunt

```bash
cd terragrunt/dev
terragrunt run-all apply
```

---

## Monitoring

### 🔹 Stack

- Prometheus
- Grafana
- Grafana Alloy

### Metrics Flow

```text
LLM → Alloy → Prometheus → Grafana
```

---

## Alerting

### Grafana Alerts

- Instance down
- High CPU usage
- Low disk space

### CloudWatch Alerts

- RDS (CPU, storage)
- ALB (4xx / 5xx)

### Notifications

- SNS → Email
- Grafana → Slack

---

## Database (RDS PostgreSQL)

Used by:

- Open WebUI

Stores:

- User prompts
- Chat history
- Application data

---

## Security

- LLM instances run in private subnets
- No public access to Ollama
- Access via:
  - Bastion host

- HTTPS handled by Nginx on Web Server
- RDS is private

---

## Key Design Decisions

- Layered Terraform architecture
- Immutable infrastructure via AMIs
- Ansible used only during AMI build
- Nginx used as HTTPS entry point and reverse proxy
- ALB for distributing traffic across LLM instances
- Alloy push model for metrics
- RDS for persistent storage
- Terragrunt for multi-layer orchestration

---