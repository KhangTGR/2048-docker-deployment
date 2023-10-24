output "application_bucket_name" {
  value = aws_s3_bucket.application.bucket
}

output "backend_bucket_name" {
  value = aws_s3_bucket.backend_bucket.bucket
}
