module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "iam" {
  source                    = "./modules/iam"
  project_name              = var.project_name
  raw_bucket                = var.raw_bucket
  raw_bucket_arn            = module.s3.raw_bucket_arn
  curated_bucket_arn        = module.s3.curated_bucket_arn
  athena_results_bucket_arn = module.s3.athena_results_bucket_arn
  api_key_ssm_arn           = "arn:aws:ssm:eu-west-2:913103947318:parameter/weather/api_key"
}

module "glue_job" {
  source              = "./modules/glue_job"
  project_name        = var.project_name
  glue_role_arn       = module.iam.glue_role_arn
  raw_bucket_name     = module.s3.raw_bucket_name
  curated_bucket_name = module.s3.curated_bucket_name
}

module "glue_crawler_raw" {
  source           = "./modules/glue_crawler_raw"
  project_name     = var.project_name
  crawler_role_arn = module.iam.crawler_role_arn
  raw_bucket_name  = module.s3.raw_bucket_name
}

module "glue_crawler_curated" {
  source              = "./modules/glue_crawler_curated"
  project_name        = var.project_name
  crawler_role_arn    = module.iam.crawler_role_arn
  curated_bucket_name = module.s3.curated_bucket_name
}

module "lambda_ingestion" {
  source          = "./modules/lambda_ingestion"
  project_name    = var.project_name
  city            = var.city
  raw_prefix      = var.raw_prefix
  raw_bucket      = var.raw_bucket
  lambda_role_arn = module.iam.lambda_role_arn
}

module "eventbridge" {
  source              = "./modules/eventbridge"
  project_name        = var.project_name
  schedule_expression = var.schedule_expression
  lambda_function_arn = module.lambda_ingestion.lambda_arn
}

