###############################################
# LAMBDA ROLE (Assume Role Policy)
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

###############################################
# LAMBDA PERMISSIONS POLICY
###############################################

data "aws_iam_policy_document" "lambda_policy" {

  # CloudWatch Logs
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }

  # Write raw JSON to RAW bucket
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = ["${var.raw_bucket_arn}/*"]
  }

  # Read API key from SSM Parameter Store
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:*:*:parameter/weather/api_key"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_role_policy" {
  name   = "${var.project_name}-lambda-policy"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_policy.json
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

data "aws_iam_policy_document" "glue_policy" {

  # Read RAW bucket
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      var.raw_bucket_arn,
      "${var.raw_bucket_arn}/*"
    ]
  }

  # Write CURATED bucket
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      var.curated_bucket_arn,
      "${var.curated_bucket_arn}/*"
    ]
  }

  # CloudWatch Logs
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role" "glue_role" {
  name               = "${var.project_name}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

resource "aws_iam_role_policy" "glue_role_policy" {
  name   = "${var.project_name}-glue-policy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_policy.json
}

###############################################
# GLUE CRAWLER ROLE
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

data "aws_iam_policy_document" "crawler_policy" {

  # Read RAW + CURATED buckets
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

  # Access Glue Data Catalog
  statement {
    effect    = "Allow"
    actions   = ["glue:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "crawler_role" {
  name               = "${var.project_name}-crawler-role"
  assume_role_policy = data.aws_iam_policy_document.crawler_assume_role.json
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

data "aws_iam_policy_document" "athena_policy" {

  # Read curated data
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      var.curated_bucket_arn,
      "${var.curated_bucket_arn}/*"
    ]
  }

  # Write query results
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      var.athena_results_bucket_arn,
      "${var.athena_results_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role" "athena_role" {
  name               = "${var.project_name}-athena-role"
  assume_role_policy = data.aws_iam_policy_document.athena_assume_role.json
}

resource "aws_iam_role_policy" "athena_role_policy" {
  name   = "${var.project_name}-athena-policy"
  role   = aws_iam_role.athena_role.id
  policy = data.aws_iam_policy_document.athena_policy.json
}
