###############################################
# S3 MODULE
###############################################

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

###############################################
# IAM MODULE
###############################################

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name

  raw_bucket     = module.s3.raw_bucket
  raw_bucket_arn = module.s3.raw_bucket_arn

  curated_bucket     = module.s3.curated_bucket
  curated_bucket_arn = module.s3.curated_bucket_arn

  scripts_bucket     = module.s3.scripts_bucket
  scripts_bucket_arn = module.s3.scripts_bucket_arn

  temp_bucket     = module.s3.temp_bucket
  temp_bucket_arn = module.s3.temp_bucket_arn

  athena_results_bucket     = module.s3.athena_results_bucket
  athena_results_bucket_arn = module.s3.athena_results_bucket_arn

  api_key_ssm_arn = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/weather/api_key"
}

###############################################
# GLUE JOB MODULE
###############################################

module "glue_job" {
  source        = "./modules/glue_job"
  project_name  = var.project_name
  glue_role_arn = module.iam.glue_role_arn

  raw_bucket_name     = module.s3.raw_bucket
  curated_bucket_name = module.s3.curated_bucket

  scripts_bucket = module.s3.scripts_bucket
  temp_bucket    = module.s3.temp_bucket
}

###############################################
# RAW CRAWLER MODULE
###############################################

module "glue_crawler_raw" {
  source           = "./modules/glue_crawler_raw"
  project_name     = var.project_name
  crawler_role_arn = module.iam.crawler_role_arn

  raw_bucket_name = module.s3.raw_bucket
  database_name   = "${var.project_name}_raw_db"
}


###############################################
# CURATED CRAWLER MODULE
###############################################

module "glue_crawler_curated" {
  source           = "./modules/glue_crawler_curated"
  project_name     = var.project_name
  crawler_role_arn = module.iam.crawler_role_arn

  curated_bucket_name = module.s3.curated_bucket
  database_name       = "${var.project_name}_curated_db"
}


###############################################
# LAMBDA INGESTION MODULE
###############################################

module "lambda_ingestion" {
  source       = "./modules/lambda_ingestion"
  project_name = var.project_name

  city       = var.city
  raw_prefix = var.raw_prefix

  raw_bucket        = module.s3.raw_bucket
  lambda_role_arn   = module.iam.lambda_role_arn
  api_key_ssm_param = "/weather/api_key"
}

###############################################
# EVENTBRIDGE SCHEDULE MODULE
###############################################

module "eventbridge" {
  source              = "./modules/eventbridge"
  project_name        = var.project_name
  schedule_expression = var.schedule_expression

  lambda_function_arn = module.lambda_ingestion.lambda_arn
}

###############################################
# AWS ACCOUNT LOOKUP
###############################################

data "aws_caller_identity" "current" {}
