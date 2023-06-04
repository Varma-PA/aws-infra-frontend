resource "aws_s3_bucket" "frontend_bucket" {

  bucket = "dev.achyuthvarma.me"

  #   acl = "public-read"  

  force_destroy = true

  tags = {
    Name = "Frontend_S3_Bucket"
  }
}

# resource "aws_s3_bucket_lifecycle_configuration" "my_lifecycle_configuration" {
#   bucket = aws_s3_bucket.frontend_bucket.id
#   rule {
#     id = "log"
#     transition {
#       days          = 30
#       storage_class = "STANDARD_IA"
#     }
#     status = "Enabled"
#   }
# }

resource "aws_s3_bucket_website_configuration" "website_config" {

  bucket = aws_s3_bucket.frontend_bucket.bucket
  index_document {
    suffix = "index.html"
  }
}

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.frontend_bucket.bucket
#   acl = "public-read"

# }

resource "aws_s3_bucket_policy" "public_access" {

  bucket = aws_s3_bucket.frontend_bucket.id
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [ "s3:*" ],
            "Resource": [
                "${aws_s3_bucket.frontend_bucket.arn}",
                "${aws_s3_bucket.frontend_bucket.arn}/*"
            ]
            }
        ]
    }
    EOF

}


# resource "aws_s3_bucket_policy" "allow_objects" {
#   bucket = aws_s3_bucket.frontend_bucket.id
# #   policy = data.aws_iam_policy_document.allow_access_to_objects.json
#   policy = templatefile("s3-policy.json", {bucket = aws_s3_bucket.frontend_bucket.id})
# }

# data "aws_iam_policy_document" "allow_access_to_objects" {

#   statement {
#     effect = "Allow"

#     principals {
#       type = "AWS"
#       identifiers = ["*"]
#     }

#     actions = [
#       "s3:GetObject"
#     ]

#     resources = [
#       aws_s3_bucket.frontend_bucket.arn, "${aws_s3_bucket.frontend_bucket.arn}/*",
#     ]

#   }

# }

resource "aws_s3_bucket_public_access_block" "block_all_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}