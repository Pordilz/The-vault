# The Vault: Secure & Compliant Cloud Archive

## 📌 Project Overview
**The Vault** is a secure cloud storage solution designed for sensitive data (e.g., medical records, legal contracts) that requires strict compliance and immutability. Built entirely on **AWS** using **Terraform**, this infrastructure enforces a "Write Once, Read Many" (WORM) model to prevent data tampering or accidental deletion.

This project was developed as part of the **Cloud Programming (DLBSEPCP01_E)** portfolio.

## 🏗 Architecture
The solution deploys a serverless architecture focused on three pillars: **Security**, **Compliance**, and **Cost Efficiency**.

* **Storage:** Amazon S3 with Versioning and Object Lock enabled.
* **Security:**
    * **Server-Side Encryption (SSE-KMS):** Uses a Customer Managed Key (CMK) for granular access control.
    * **Public Access Block:** Strictly prohibits all public internet access to the bucket.
* **Compliance:** S3 Object Lock in **Compliance Mode** ensures files cannot be deleted or overwritten for a set retention period (365 days).
* **Cost Optimization:** An S3 Lifecycle Rule automatically transitions objects to **Glacier Deep Archive** after 30 days.

## 🛠️ Technologies Used
* **Cloud Provider:** Amazon Web Services (AWS)
* **Infrastructure as Code:** Terraform (HCL)
* **IDE:** Visual Studio Code

## 🚀 How to Deploy

### Prerequisites
* [Terraform](https://www.terraform.io/downloads) installed (v1.0+)
* AWS CLI configured with appropriate credentials (`aws configure`)

### Installation Steps
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Pordilz/the-vault-project.git](https://github.com/Pordilz/the-vault-project.git)
    cd the-vault-project
    ```

2.  **Initialize Terraform:**
    Downloads the required AWS provider plugins.
    ```bash
    terraform init
    ```

3.  **Review the Plan:**
    See what resources will be created before deploying.
    ```bash
    terraform plan
    ```

4.  **Deploy Infrastructure:**
    Provision the S3 bucket, KMS key, and policies.
    ```bash
    terraform apply
    ```
    *(Type `yes` when prompted)*

5.  **Clean Up (Optional):**
    To avoid ongoing costs, destroy the resources when finished.
    ```bash
    terraform destroy
    ```

## 📂 Project Structure
```text
.
├── main.tf          # Main configuration file containing all resources
├── .gitignore       # Ignores Terraform state files and secrets
└── README.md        # Project documentation
