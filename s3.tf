resource "aws_s3_bucket" "parson_bucket" {
  bucket = "parson-bucket-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "parson-bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 6
}

resource "aws_s3_bucket_public_access_block" "disable_public_access_block" {
  bucket = aws_s3_bucket.parson_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "parson_public_read" {
  bucket = aws_s3_bucket.parson_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.parson_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "parson_website" {
  bucket = aws_s3_bucket.parson_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.parson_bucket.id
  key          = "index.html"
  source       = "index.html"
  etag         = filemd5("index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.parson_bucket.id
  key          = "error.html"
  source       = "error.html"
  etag         = filemd5("error.html")
  content_type = "text/html"
}

output "bucket_name" {
  value = aws_s3_bucket.parson_bucket.id
}