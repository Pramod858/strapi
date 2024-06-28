# Data source to get the latest Ubuntu AMI ID from Amazon's AWS account
data "aws_ami" "latest_ubuntu" {
    most_recent = true
    owners      = ["amazon"]  # Amazon's AWS account ID for public Ubuntu AMIs

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  # Example for Ubuntu 20.04
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}

# Data source to get the default VPC
data "aws_vpc" "default" {
    default = true
}

# Generate an RSA private key of size 4096 bits
resource "tls_private_key" "Strapi_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Create the AWS key pair using the generated public key
resource "aws_key_pair" "Strapi_key_key" {
    key_name   = "Strapi-key"
    public_key = tls_private_key.Strapi_key.public_key_openssh
}

# Resource to upload the generated private key to the same S3 bucket used for Terraform state
resource "aws_s3_object" "strapi_private_key" {
    bucket  = var.my_s3_bucket  # The same bucket used for Terraform state
    key     = "private_key/Strapi_key.pem"
    content = tls_private_key.Strapi_key.private_key_pem
}

# Create a security group for the Strapi application
resource "aws_security_group" "Strapi_SG" {
    name        = "security_group_for_strapi"
    description = "Security group for Strapi application"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH"
    }

    ingress {
        from_port   = 1337
        to_port     = 1337
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP"
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

# Launch an EC2 instance using the created key pair
resource "aws_instance" "web" {
    ami             = data.aws_ami.latest_ubuntu.id
    instance_type   = var.instance_type
    security_groups = [aws_security_group.Strapi_SG.name]
    key_name        = aws_key_pair.Strapi_key_key.key_name
    user_data       = file("Strapi.sh")  # Path to the user data script for initializing Strapi
    
    root_block_device {
        volume_size = 15
    }
    tags = {
        Name = "Strapi"
    }
}
