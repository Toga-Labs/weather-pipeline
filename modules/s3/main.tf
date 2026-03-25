###############################################
# RAW BUCKET (input zone)
###############################################

resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-raw-data-tg"
}

###############################################
# CURATED BUCKET (output zone)
###############################################

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project_name}-curated-data-tg"
}

###############################################
# ATHENA RESULTS BUCKET
###############################################

resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.project_name}-athena-results-tg"
}

###############################################
# TEMP BUCKET (Glue TempDir)
###############################################

resource "aws_s3_bucket" "temp" {
  bucket = "${var.project_name}-temp-data-tg"
}

###############################################
# SCRIPTS BUCKET (Glue ETL scripts)
###############################################

resource "aws_s3_bucket" "scripts" {
  bucket = "${var.project_name}-scripts-tg"
}
