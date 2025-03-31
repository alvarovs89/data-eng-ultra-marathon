### Provisioned GCP Resources
The following resources will be provisioned in Google Cloud Platform (GCP):
- **GCS Bucket**
- **Google BigQuery**

### 🛠️ Prerequisites
Ensure the following tools and configurations are in place before proceeding:
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your system.
- [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install) installed and authenticated.
- A GCP Service Account with the necessary permissions to manage the resources.

### 🔑 Authentication
1. Download your service account key file from the GCP Console.
2. Rename the downloaded key file to `my-creds.json` and place it inside the [keys folder](/keys/).

### 🚀 Deploying Infrastructure
Follow these steps to deploy the infrastructure:

1. Navigate to the Terraform directory:
    ```bash
    cd 01-terraform
    ```

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Create a Terraform execution plan:
    ```bash
    terraform plan
    ```

4. Apply the Terraform configuration to provision resources:
    ```bash
    terraform apply
    ```

### 🧹 Clean Up Resources
To destroy all provisioned resources and clean up, run:
```bash
terraform destroy
```