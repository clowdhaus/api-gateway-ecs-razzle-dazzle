# api-gateway-ecs-razzle-dazzle
I love this pattern

## Setup

1. Provision the CI/CD resources defined in `cicd/`
2. Set Github action secrets
  - `AWS_DEFAULT_REGION` - The region where the resources are/will be provisioned
  - `AWS_IAM_ROLE` - The GitHub OIDC IAM role ARN; Terraform output `github_oidc_iam_role_arn`
