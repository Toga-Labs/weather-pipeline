resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-raw-data-tg"
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project_name}-curated-data-tg"
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.project_name}-athena-results-tg"
}

resource "aws_s3_bucket" "scripts" {
  bucket = "${var.project_name}-scripts-tg"
}
