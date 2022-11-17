provider "aws" {
    profile = "andres"
    region = var.region
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-andres-state"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_dynamo" {
  name             = "tf-andres-locks"
  hash_key         = "LockID"
  billing_mode     = "PAY_PER_REQUEST"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}