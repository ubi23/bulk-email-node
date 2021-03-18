resource "aws_s3_bucket" "releases" {
  bucket        = replace(substr(join("-", [var.tags.Service, "artifact-codebuild"]), 0, 63), "/-$/", "")
  acl           = "private"
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_policy" "releasespolicy" {
  bucket = aws_s3_bucket.releases.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "SSEAndSSLPolicy",
    "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.releases.id}/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        },
        {
            "Sid": "DenyInsecureConnections",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.releases.id}/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}
