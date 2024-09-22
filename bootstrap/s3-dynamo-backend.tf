# Create the S3 bucket
resource "aws_s3_bucket" "tf_state" {
  bucket = "pet-clinic-tf-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "pet-clinic-tf-state"
  }
}

# Create the DynamoDB table for state locking
resource "aws_dynamodb_table" "state_lock" {
  name         = "pet-clinic-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "pet-clinic-tf-state-lock"
  }
}
