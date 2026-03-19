output "athena_database_name" {
  value = aws_athena_database.curated_db.name
}

output "athena_workgroup_name" {
  value = aws_athena_workgroup.primary.name
}
