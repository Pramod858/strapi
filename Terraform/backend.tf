terraform {
    backend "s3" {
        bucket = "pramod858tf"
        key    = "Strapi/terraform.tfstate"
        region = "us-east-1"
    }
}
