
###############################################
# OPTIONAL: INFRA MODULES (RUN ONLY IF ENABLED)
###############################################

module "s3" {
  source = "./modules/s3"
  count  = var.enable_infra ? 1 : 0

  project_name = var.project_name
}

module "iam" {
  source = "./modules/iam"
  count  = var.enable_infra ? 1 : 0

  project_name = var.project_name

  raw_bucket_arn            = var.enable_infra ? module.s3[0].raw_bucket_arn : null
  curated_bucket_arn        = var.enable_infra ? module.s3[0].curated_bucket_arn : null
  athena_results_bucket_arn = var.enable_infra ? module.s3[0].athena_results_bucket_arn : null
}

module "glue_job" {
  source = "./modules/glue_job"
  count  = var.enable_infra ? 1 : 0

  project_name  = var.project_name
  glue_role_arn = module.iam[0].glue_role_arn

  raw_bucket_name     = module.s3[0].raw_bucket_name
  curated_bucket_name = module.s3[0].curated_bucket_name
}

module "glue_crawler_raw" {
  source = "./modules/glue_crawler_raw"
  count  = var.enable_infra ? 1 : 0

  project_name     = var.project_name
  crawler_role_arn = module.iam[0].crawler_role_arn
  raw_bucket_name  = module.s3[0].raw_bucket_name
}

###############################################
# LAMBDA INGESTION MODULE (SELF-CONTAINED)
###############################################

module "lambda_ingestion" {
  source = "./modules/lambda_ingestion"

  project_name    = var.project_name
  weather_api_key = var.weather_api_key
  raw_prefix      = var.raw_prefix

  # Buckets can come from infra OR be manually created
  scripts_bucket = var.scripts_bucket
  raw_bucket     = var.raw_bucket
  city           = var.city
}
