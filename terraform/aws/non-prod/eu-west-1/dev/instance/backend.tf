# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "terragrunt-tf-state-non-prod-eu-west-1"
    dynamodb_table = "tf-locks"
    encrypt        = true
    key            = "non-prod/eu-west-1/dev/instance/tf.tfstate"
    region         = "eu-west-1"
  }
}
