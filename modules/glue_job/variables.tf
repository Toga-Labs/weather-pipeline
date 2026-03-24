variable "project_name" {
  type = string
}

variable "glue_role_arn" {
  type = string
}

variable "raw_bucket_name" {
  type = string
}

variable "curated_bucket_name" {
  type = string
}

variable "glue_database_name" {
  type        = string
  description = "Name of the Glue database for the curated table"
}

variable "glue_table_name" {
  type        = string
  description = "Name of the Glue table created by the crawler"
}
