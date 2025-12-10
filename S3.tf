resource "random_id" "suffix" {
  byte_length = 4
}

# ----------------------------------------------
# DATA LAKE BUCKET
# ----------------------------------------------
resource "aws_s3_bucket" "data_lake" {
  bucket = "data-lake-${random_id.suffix.hex}"

  tags = merge(local.common_tags, {
    Name = "Athena Data Lake"
  })
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.data_lake.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake_sse" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "data_lake_versioning" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "athena-query-results-${var.env}-${random_id.suffix.hex}"

  force_destroy = false

  tags = merge(local.common_tags, {
    Environment = var.env
    Purpose     = "Athena Query Results"
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results_sse" {
  bucket = aws_s3_bucket.athena_results.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "athena_results_versioning" {
  bucket = aws_s3_bucket.athena_results.id

  versioning_configuration {
    status = "Enabled"
  }
}
