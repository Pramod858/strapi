# Strapi Deployment on EC2 using Terraform

This repository contains Terraform configurations for deploying the Strapi application on an EC2 instance. The configurations are designed to set up and manage the infrastructure required to run Strapi, including creating an EC2 instance and configuring it with the necessary software.

## Prerequisites

Before you begin, ensure you have the following:

- AWS account with IAM user credentials (Access Key ID and Secret Access Key)
- An S3 bucket for storing Terraform state files

## Repository Structure

- `main.tf`: Main Terraform configuration file.
- `variables.tf`: Variables required for the Terraform configuration.
- `outputs.tf`: Outputs from the Terraform configuration.
- `backend.tf`: Configuration for Terraform remote state storage.
- `.github/workflows/terraform-deploy.yml`: GitHub Actions workflow for applying or destroying the Terraform configuration.

## Setting up the S3 Bucket for Remote State Storage

To store Terraform state files remotely, you need to create an S3 bucket. This is necessary for managing and storing the state of your infrastructure securely.

1. Log in to your AWS Management Console.
2. Navigate to the S3 service.
3. Create a new bucket with a unique name (e.g., `my-terraform-state-bucket`).
4. Note the bucket name and region.

## Configuring `backend.tf`

Edit the `backend.tf` file to include your S3 bucket details:

```hcl
terraform {
  backend "s3" {
    bucket = "you-bucket-name"  # Replace with your S3 bucket name
    key    = "Strapi/terraform.tfstate"  # Replace with your desired path
    region = "us-west-1"                  # Replace with your S3 bucket region
  }
}
```
Edit the `variables.tf` file to include your S3 bucket details:

```hcl
variable "my_s3_bucket" {
    type = string
    default = "your-bucket-name"
}
```
## GitHub Actions Workflow

This repository includes a GitHub Actions workflow to apply or destroy the Terraform configuration. You can manually trigger the workflow from the "Actions" tab in your GitHub repository.

### Running the Workflow

1. Go to the "Actions" tab in your GitHub repository.
2. Select the "Apply or Destroy Strapi with Terraform" workflow.
3. Click "Run workflow" and choose the desired action (`apply` or `destroy`).

## Secrets

Ensure you have the following secrets set up in your GitHub repository:

- `PRAMOD_AWS_ACCESS_KEY_ID`
- `PRAMOD_AWS_SECRET_ACCESS_KEY`
- `PRAMOD_AWS_REGION`

These secrets are necessary for configuring AWS credentials in the GitHub Actions workflow.

## Conclusion

By following the steps in this README, you can deploy and manage a Strapi application on an EC2 instance using Terraform. The configuration also supports remote state storage in an S3 bucket to ensure the state of your infrastructure is managed securely.

Feel free to contribute to this repository by creating issues or submitting pull requests.
