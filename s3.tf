resource "aws_s3_bucket" "nextcloud_storage" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true

  tags = {
    Name        = "nextcloud_bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.nextcloud_storage.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}