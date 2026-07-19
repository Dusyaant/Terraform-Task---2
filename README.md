```
              +-----------------------------------+
              |      Terraform Core Engine        |
              |     (State & Dependency Graph)     |
              +-----------------------------------+
                                |
        +-----------------------+-----------------------+
        |                                               |
        v                                               v
+-----------------------+                       +-----------------------+
|  Provider: Primary    |                       |   Provider Alias:     |
|  (aws / us-east-1)    |                       |   (aws.oregon /       |
|                       |                       |    us-west-2)         |
+-----------------------+                       +-----------------------+
|                                               |
v                                               v
+-----------------------+                       +-----------------------+
|  Dynamic AMI Fetch    |                       |  Dynamic AMI Fetch    |
|  Ubuntu 24.04 LTS     |                       |  Ubuntu 24.04 LTS     |
+-----------------------+                       +-----------------------+
|                                               |
v                                               v
+-----------------------+                       +-----------------------+
|  EC2 Node: t3.micro   |                       |  EC2 Node: t3.micro   |
| "ec2_region_one"      |                       | "ec2_region_two"      |
+-----------------------+                       +-----------------------+
|                                               |
v [User Data Bootstrap]                         v [User Data Bootstrap]
+-----------------------+                       +-----------------------+
| 1. apt-get update     |                       | 1. apt-get update     |
| 2. apt install nginx  |                       | 2. apt install nginx  |
| 3. systemctl enable   |                       | 3. systemctl enable   |
| 4. Inject Custom HTML |                       | 4. Inject Custom HTML |
+-----------------------+                       +-----------------------+
|                                               |
v                                               v
[Public Web Port 80]                            [Public Web Port 80]
Nginx Live: US-East-1                           Nginx Live: US-West-2

```

---

## ⚙️ Automated Bootstrapping Logic

Unlike plain infrastructure provisioning, Task-2 utilizes automated configuration hooks. When the virtual compute layers initialize, a localized bash script executes at root-level privilege to handle software provisioning:

```bash
#!/bin/bash
sudo apt-get update -y          # Synchronizes localized package registry database
sudo apt-get install nginx -y   # Downloads and installs Nginx server binaries
sudo systemctl start nginx      # Activates the Nginx runtime daemon process
sudo systemctl enable nginx     # Modifies boot targets to persist server state
echo "<h1>Nginx Running via Terraform...</h1>" | sudo tee /var/www/html/index.html

```

---

## 🚀 Deployment Orchestration Run-Guide

### 📋 Environment Prerequisites

* **Terraform Engine CLI** installed locally (v1.5.0+).
* **AWS CLI v2** pre-configured via local cryptographic access tokens.
* Cloud administrative permissions mapping to Amazon EC2 and IAM namespaces.

### 🏁 1. Map Environment Profile

Ensure your host shell references the appropriate access permissions vectors:

```cmd
aws configure

```

*Provide your active AWS access parameters (Access Key ID, Secret Key, and `us-east-1` default region profile when prompted).*

### 📁 2. Workspace Initialization

Switch into your dedicated execution directory containing your structural asset configurations, and run the dependency map setup:

```cmd
cd %USERPROFILE%\\Desktop\\Terraform-Nginx-Task2
terraform init

```

### 🔍 3. Build Preview Auditing

Audit the orchestration dependencies map before provisioning to remote APIs. The output must evaluate exactly 2 elements to add:

```cmd
terraform plan

```

### ⚡ 4. Live Environment Materialization

Execute the live build. Confirm state transitions by inputting `yes` into the terminal window:

```cmd
terraform apply

```

---

## 🗂️ Project Submission Verification Artifacts

To meet fulfillment standards for evaluation, verify and upload the following system deliverables:

1. **`01_Terminal_Apply_Success.png`**: Screenshot documenting successful deployment context from command line showing `Apply complete! Resources: 2 added`.
2. **`02_AWS_Virginia_EC2.png`**: Management console screenshot verifying running `Nginx-Virginia-Region` compute profile with target Public IP details visible.
3. **`03_AWS_Oregon_EC2.png`**: Management console screenshot verifying running `Nginx-Oregon-Region` compute profile under the `us-west-2` regional index filter.

---
You have completely mastered cross-regional cloud automation and server bootstrapping today. Awesome job pushing through all the real-world engineering obstacles! Let me know if you run into any formatting or setup issues on GitHub.

```
