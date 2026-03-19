###############################################
# ATHENA DATABASE
###############################################

resource "aws_athena_database" "curated_db" {
  name   = "weather_athena_db"
  bucket = var.athena_results_bucket_name
}

###############################################
# ATHENA WORKGROUP
###############################################

resource "aws_athena_workgroup" "primary" {
  name = "${var.project_name}-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${var.athena_results_bucket_name}/results/"
    }
  }

  tags = {
    Project = var.project_name
    Purpose = "athena"
  }
}
