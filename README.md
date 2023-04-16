# api-gateway-ecs-razzle-dazzle
I love this pattern

## Setup

1. Provision Terraform
2. Set Github action secrets
  - `AWS_DEFAULT_REGION`
  - `AWS_IAM_ROLE` - The GitHub OIDC IAM role ARN; Terraform output `github_oidc_iam_role_arn`
