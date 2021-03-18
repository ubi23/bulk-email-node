output "codebuild_name" {
  value       = join("", aws_codebuild_project.main[*].name)
  description = "one-off task."
}
