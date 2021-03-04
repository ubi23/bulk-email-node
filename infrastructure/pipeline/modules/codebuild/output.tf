output "codebuild_name" {
  value       = join("", aws_codebuild_project.main[*].name)
  description = "We will use the name of each codebuild as part of the codepipeline."
}
