resource "aws_iam_user" "nextcloud_user" {
  name = "nextcloud_user"

  tags = {
    Name = "nextcloud"
  }
}

resource "aws_iam_policy" "nextcloud_policy" {
  name        = "nextcloud_policy"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": ["${aws_s3_bucket.nextcloud_storage.arn}","${aws_s3_bucket.nextcloud_storage.arn}/*"]
    }
  ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "attachment" {
  user       = aws_iam_user.nextcloud_user.name
  policy_arn = aws_iam_policy.nextcloud_policy.arn
}

resource "aws_iam_access_key" "nextcloud_access_key" {
  user    = aws_iam_user.nextcloud_user.name
}