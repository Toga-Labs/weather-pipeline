###############################################
# RAW BUCKET OUTPUTS
###############################################

output "raw_bucket" {
  value = aws_s3_bucket.raw.bucket
}

output "raw_bucket_arn" {
  value = aws_s3_bucket.raw.arn
}

###############################################
# CURATED BUCKET OUTPUTS
###############################################

output "curated_bucket" {
  value = aws_s3_bucket.curated.bucket
}

output "curated_bucket_arn" {
  value = aws_s3_bucket.curated.arn
}

###############################################
# ATHENA RESULTS BUCKET OUTPUTS
###############################################

output "athena_results_bucket" {
  value = aws_s3_bucket.athena_results.bucket
}

output "athena_results_bucket_arn" {
  value = aws_s3_bucket.athena_results.arn
}

###############################################
# TEMP BUCKET OUTPUTS
###############################################

output "temp_bucket" {
  value = aws_s3_bucket.temp.bucket
}

output "temp_bucket_arn" {
  value = aws_s3_bucket.temp.arn
}

###############################################
# SCRIPTS BUCKET OUTPUTS
###############################################

output "scripts_bucket" {
  value = aws_s3_bucket.scripts.bucket
}

output "scripts_bucket_arn" {
  value = aws_s3_bucket.scripts.arn
}
