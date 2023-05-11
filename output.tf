output "arns" {
  value = [for k in resource.aws_ecr_repository.default : k.arn]
}

output "repository_url" {
  value = { for k, v in resource.aws_ecr_repository.default : k => v.repository_url }
}
