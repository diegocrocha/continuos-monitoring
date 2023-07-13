# Terraform and Ansible Project CI-Monitoring

This project automates the deployment and configuration of a monitoring setup using Prometheus, Node Exporter, Grafana and MariaDB. It utilizes Terraform for infrastructure provisioning and Ansible for configuration management.

## Prerequisites

Before running this project, ensure that you have the following:

- Terraform installed on your local machine.
- Ansible installed on your local machine.
- AWS access credentials configured on your local machine.
- An SSH key pair (.pem file) for accessing the EC2 instances.

## Getting Started

### 1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/diegocrocha/continuos-monitoring
   cd continuos-monitoring
```

### 2. Update the following files with your specific configuration:

   - `private_key_file`: Change the .pem at ansible.cfg.
   - `key_name`:  Change the .pem at ci-ec2.tf and node-ec2.tf
   - `ansible/inventory.ini`: Create the iventoy.ini with the group [monitoring] and [node] and pass the IP addresses with the actual IP addresses of your EC2 instances.

## Deployment

To deploy the infrastructure and configure the servers, follow these steps:

### 1. Provision the infrastructure using Terraform:

   ```bash
   cd terraform
   terraform init
   terraform apply
```
Once the infrastructure is provisioned, update the inventory file with the actual IP addresses of the EC2 instances.

### 2. Run the Ansible playbook to configure the servers:

   ```bash
   cd ../ansible
   ansible-playbook -i inventory.ini playbook.yml
```
This will install and configure Prometheus, Node Exporter, and MariaDB on the respective servers.

## Cleanup

To clean up and remove the deployed infrastructure, follow these steps:

### 1. Run the following command to destroy the Terraform resources:
   ```bash
   cd ../terraform
   terraform destroy
```
Confirm the destruction when prompted.

### 2. Verify that all resources have been successfully removed from your AWS account.