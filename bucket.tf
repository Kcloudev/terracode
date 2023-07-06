resource "aws_s3_bucket" "agency_bucket" {
  bucket = "${var.bucket_unique_name}"
  tags = {
    Name        = "My bucket"
    Environment = "Prod"
  }
}
resource "aws_iam_role" "s3_read_write_access_role" {
  name = "s3-read-write-access-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "s3_read_write_access_policy" {
  name        = "s3-read-write-access-policy"
  description = "Allows read and write access to the EC2"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_read_write_access_attachment" {
  role       = aws_iam_role.s3_read_write_access_role.name
  policy_arn = aws_iam_policy.s3_read_write_access_policy.arn
}

