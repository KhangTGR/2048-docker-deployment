resource "aws_s3_bucket" "application" {
  bucket = "${var.prefix}-${var.s3_bucket_application.name}"
}

resource "aws_s3_object" "application_source" {
  bucket = aws_s3_bucket.application.id

  for_each = fileset("../source/", "**/*.*")

  key          = each.value
  source       = "../source/${each.value}"
  content_type = each.value
}
