
###############################################
# S3 BUCKETS (RAW, CURATED, ATHENA RESULTS)
###############################################
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

###############################################
# IAM ROLES (Lambda, Glue, Crawlers, Athena)
###############################################
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name

  raw_bucket_arn            = module.s3.raw_bucket_arn
  curated_bucket_arn        = module.s3.curated_bucket_arn
  athena_results_bucket_arn = module.s3.athena_results_bucket_arn
}

###############################################
# LAMBDA INGESTION FUNCTION
###############################################
module "lambda_ingestion" {
  source = "./modules/lambda_ingestion"

  project_name    = var.project_name
  lambda_role_arn = module.iam.lambda_role_arn

  city            = var.city
  weather_api_key = var.weather_api_key

  raw_bucket_name = module.s3.raw_bucket_name
  raw_prefix      = var.raw_prefix

  scripts_bucket = var.scripts_bucket
}

###############################################
# GLUE ETL JOB
###############################################
module "glue_job" {
  source        = "./modules/glue_job"
  project_name  = var.project_name
  glue_role_arn = module.iam.glue_role_arn

  raw_bucket_name     = module.s3.raw_bucket_name
  curated_bucket_name = module.s3.curated_bucket_name
}

module "glue_crawler_raw" {
  source           = "./modules/glue_crawler_raw"
  project_name     = var.project_name
  crawler_role_arn = module.iam.crawler_role_arn
  raw_bucket_name  = module.s3.raw_bucket_name
}

