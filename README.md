# System Administrator Infrastructure Task

This repository contains the infrastructure code for deploying a minimal PHP application using Nginx + PHP-FPM, managed via Terraform and configured with Ansible.

## Project Structure

- `ansible/` - Ansible playbooks and roles for generating configuration files.
- `terraform/` - Terraform code to provision Docker infrastructure.
- `.github/workflows/` - CI/CD pipelines for linting and validation.
- `Decisions.md` - Architectural decisions and explanations.

## Prerequisites

- Docker
- Terraform
- Ansible

## Deployment Guide

### Step 1: Generate Configurations with Ansible
Ansible is used to generate the necessary `nginx.conf` and `index.php` files based on templates.

```bash
cd ansible
ansible-playbook playbooks/site.yml
```

This will create a generated_config/ directory in the project root.

### Step 2: Provision Infrastructure with Terraform

Terraform uses the generated configurations and deploys the Docker containers.


```bash
cd terraform
terraform init
terraform apply
```

## Validation

After a successful deployment, verify the application health check:

```bash
curl http://localhost:8080/healthz
```
#### Expected Output:

```JSON
{"status":"ok","service":"nginx","env":"dev"}
```

## CI/CD Results

Links to successful GitHub Actions runs:

[Terraform Workflow](https://github.com/iracon228/test-as-infra/actions/runs/20324905352)

[Ansible Workflow](https://github.com/iracon228/test-as-infra/actions/runs/20324905349)

