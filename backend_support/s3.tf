resource "aws_s3_bucket" "mys3bucket" {
  bucket = "${var.prefix}-tfstate"
  force_destroy = false

  tags = {
    Name        = "${var.prefix}-tfstate"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_versioning" "myversion" {
  bucket = aws_s3_bucket.mys3bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
resource "aws_s3_bucket_server_side_encryption_configuration" "myencryption" {
  bucket = aws_s3_bucket.mys3bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "mypubaccess" {
  bucket = aws_s3_bucket.mys3bucket.bucket

  block_public_acls       = true
  ignore_public_acls       = true
  block_public_policy      = true
  restrict_public_buckets  = true
}