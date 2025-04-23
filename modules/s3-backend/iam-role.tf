resource "aws_iam_role" "replication" {
  provider = aws.state
  name     = format("%s-%s-s3-replication-role", var.config.tags["environment"], var.config.tags["project"])

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
  tags               = var.config.tags
}

resource "aws_iam_policy" "replication" {
  provider = aws.state
  name     = format("%s-%s-s3-replication-policy", var.config.tags["environment"], var.config.tags["project"])

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.state.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"

      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.backup.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "replication" {
  provider   = aws.state
  name       = format("%s-%s-s3-replication-policy-attachment", var.config.tags["environment"], var.config.tags["project"])
  roles      = ["${aws_iam_role.replication.name}"]
  policy_arn = aws_iam_policy.replication.arn
}