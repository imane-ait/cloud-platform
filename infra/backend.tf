terraform {
  backend "s3" {
    bucket         = "fleetops-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
