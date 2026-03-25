###############################################
# LAMBDA ROLE
###############################################

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "${var.project_name}-lambda-s3-access"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "arn:aws:s3:::${var.raw_bucket}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter", "ssm:GetParameters"]
        Resource = var.api_key_ssm_arn
      }
    ]
  })
}

###############################################
# GLUE JOB ROLE
###############################################

data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "glue_role" {
  name               = "${var.project_name}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

data "aws_iam_policy_document" "glue_policy" {
  # S3 access for raw, curated, and scripts buckets
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      var.raw_bucket_arn,
      "${var.raw_bucket_arn}/*",
      var.curated_bucket_arn,
      "${var.curated_bucket_arn}/*",
      var.scripts_bucket_arn,
      "${var.scripts_bucket_arn}/*"
    ]
  }

  # Logs + CloudWatch metrics (THIS FIXES YOUR FAILURE)
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "glue_role_policy" {
  name   = "${var.project_name}-glue-policy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_policy.json
}

###############################################
# CRAWLER ROLE
###############################################

data "aws_iam_policy_document" "crawler_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "crawler_role" {
  name               = "${var.project_name}-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role.json
}

data "aws_iam_policy_document" "crawler_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      var.raw_bucket_arn,
      "${var.raw_bucket_arn}/*",
      var.curated_bucket_arn,
      "${var.curated_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "glue:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "crawler_role_policy" {
  name   = "${var.project_name}-crawler-policy"
  role   = aws_iam_role.crawler_role.id
  policy = data.aws_iam_policy_document.crawler_policy.json
}

###############################################
# ATHENA ROLE
###############################################

data "aws_iam_policy_document" "athena_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["athena.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "athena_role" {
  name               = "${var.project_name}-athena-role"
  assume_role_policy = data.aws_iam_policy_document.athena_assume_role.json
}

data "aws_iam_policy_document" "athena_policy" {
  statement {
    effect = "Allow"
    actions = [
      "athena:*",
      "glue:*",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "athena_role_policy" {
  name   = "${var.project_name}-athena-policy"
  role   = aws_iam_role.athena_role.id
  policy = data.aws_iam_policy_document.athena_policy.json
}

