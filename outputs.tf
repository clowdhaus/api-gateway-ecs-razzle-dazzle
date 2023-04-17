output "github_oidc_iam_role_arn" {
  description = "The ARN of the GitHub OIDC IAM role"
  value       = module.github_oidc_iam_role.arn
}

output "api_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.api_gateway.stage_invoke_url
}
