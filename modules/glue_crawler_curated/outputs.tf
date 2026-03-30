output "curated_crawler_name" {
  value       = aws_glue_crawler.curated_crawler.name
  description = "Name of the CURATED Glue crawler"
}
