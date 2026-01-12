provider "aws" {
  region = "eu-central-1" # Change to your preferred region
}

# 1. Security: Create a Customer Managed KMS Key for Encryption
resource "aws_kms_key" "vault_key" {
  description             = "KMS key for The Vault document encryption"
  deletion_window_in_days = 10
}

# 2. Storage: The S3 Bucket
resource "aws_s3_bucket" "vault" {
  bucket_prefix = "secure-vault-" # Ensures a unique name
  
  # Requirement: Object Lock must be enabled for WORM compliance
  object_lock_enabled = true 
}

# 3. Security: Block ALL Public Access (Crucial for "The Vault")
resource "aws_s3_bucket_public_access_block" "vault_access" {
  bucket = aws_s3_bucket.vault.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 4. Compliance: Enable Versioning (Required for Object Lock)
resource "aws_s3_bucket_versioning" "vault_versioning" {
  bucket = aws_s3_bucket.vault.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 5. Compliance: Object Lock Configuration (WORM)
resource "aws_s3_bucket_object_lock_configuration" "vault_lock" {
  bucket = aws_s3_bucket.vault.id

  rule {
    default_retention {
      mode = "COMPLIANCE" # Files cannot be deleted by anyone, including root
      days = 365          # Retention period (e.g., 1 year)
    }
  }
}

# 6. Security: Enforce Server-Side Encryption with KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "vault_encrypt" {
  bucket = aws_s3_bucket.vault.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.vault_key.arn
    }
  }
}

# 7. Cost Efficiency: Lifecycle Rule (Transition to Glacier)
resource "aws_s3_bucket_lifecycle_configuration" "vault_lifecycle" {
  bucket = aws_s3_bucket.vault.id

  rule {
    id     = "archive-old-documents"
    status = "Enabled"

    # Move files to Glacier Deep Archive after 30 days to save money
    transition {
      days          = 30
      storage_class = "DEEP_ARCHIVE"
    }
  }
}