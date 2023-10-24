resource "aws_s3_bucket" "backend_bucket" {
  bucket = "${var.prefix}-application-backend-tfstate-bucket"
}

resource "aws_s3_bucket_ownership_controls" "backend_bucket_ownership_controls" {
  bucket = aws_s3_bucket.backend_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "backend_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.backend_bucket_ownership_controls]

  bucket = aws_s3_bucket.backend_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "backend_bucket_versioning" {
  bucket = aws_s3_bucket.backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "backend_bucket_encryption" {
  bucket = aws_s3_bucket.backend_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "backend_bucket_object" {
  bucket                 = aws_s3_bucket.backend_bucket.id
  key                    = "state/terraform.tfstate"
  source                 = "terraform.tfstate"
  content_type           = "application/json"
  server_side_encryption = "AES256"
  depends_on = [
    aws_s3_bucket.backend_bucket
  ]
}
