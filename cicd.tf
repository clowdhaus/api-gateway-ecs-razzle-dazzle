################################################################################
# GitHub IAM Role
################################################################################

module "github_oidc_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "~> 5.17"

  subjects = ["clowdhaus/${local.name}:*"]
  policies = {
    ECRWrite = aws_iam_policy.ecr_write.arn
  }

  tags = module.tags.tags
}

resource "aws_iam_policy" "ecr_write" {
  name        = "${local.name}-ecr-write"
  description = "GitHub OIDC IAM role write to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        Resource = module.ecr.repository_arn
      },
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      }
    ]
  })

  tags = module.tags.tags
}

################################################################################
# ECR Repository
################################################################################

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 1.6"

  repository_name = local.name

  repository_read_write_access_arns = [module.github_oidc_iam_role.arn]
  repository_force_delete           = true
  create_lifecycle_policy           = false

  tags = module.tags.tags
}
