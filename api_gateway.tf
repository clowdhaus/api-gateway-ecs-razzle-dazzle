################################################################################
# API Gateway
################################################################################

module "api_gateway" {
  source = "./modules/api-gateway"

  name   = local.name
  create = local.create_ecs

  integrations = {
    "ANY /" = {
      description        = "/ route for razzle dazzle"
      connection_type    = "VPC_LINK"
      vpc_link           = "this-link"
      integration_uri    = data.aws_service_discovery_service.this.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    }
    "GET /hello" = {
      description        = "/hello route for razzle dazzle"
      connection_type    = "VPC_LINK"
      vpc_link           = "this-link"
      integration_uri    = data.aws_service_discovery_service.this.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "GET"
    }
    "GET /healthz" = {
      description        = "/healthz route for razzle dazzle"
      connection_type    = "VPC_LINK"
      vpc_link           = "this-link"
      integration_uri    = data.aws_service_discovery_service.this.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "GET"
    }
    "GET /goodbye" = {
      description        = "/goodbye route for razzle dazzle"
      connection_type    = "VPC_LINK"
      vpc_link           = "this-link"
      integration_uri    = data.aws_service_discovery_service.this.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "GET"
    }
  }

  vpc_links = {
    this-link = {
      name               = local.name
      security_group_ids = [try(aws_security_group.vpc_link[0].id, null)]
      subnet_ids         = module.vpc.private_subnets
    }
  }

  tags = module.tags.tags
}

resource "aws_security_group" "vpc_link" {
  count = local.create_ecs ? 1 : 0

  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.tags.tags
}
