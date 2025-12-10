resource "aws_iam_role" "athena_role" {
  name = "athena-execution-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "athena.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "athena_policy" {
  name = "athena-policy-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*",
          aws_s3_bucket.athena_results.arn,
          "${aws_s3_bucket.athena_results.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:GetTables"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "athena_attach" {
  policy_arn = aws_iam_policy.athena_policy.arn
  role       = aws_iam_role.athena_role.name
}

resource "aws_iam_role" "glue_role" {
  name = "glue-crawler-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "Glue-Crawler-Role"
  })
}


resource "aws_iam_role_policy" "glue_basic_policy" {
  name = "glue-basic-policy-${var.env}"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:CreateTable",
          "glue:UpdateTable",
          "glue:CreateDatabase",
          "glue:UpdateDatabase"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}


resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "glue-s3-policy-${var.env}"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ListBucket",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.data_lake.arn
        ]
      },
      {
        Sid    = "ReadObjects",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "glue_policy" {
  name = "glue-crawler-policy-${var.env}"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.data_lake.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.data_lake.bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = "*"
      }
    ]
  })
}


