################################################################################
# API Gateway
################################################################################

module "api_gateway" {
  source = "./modules/api-gateway"

  name = local.name

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
      name       = local.name
      subnet_ids = module.vpc.private_subnets
    }
  }

  vpc_id = module.vpc.vpc_id
  security_group_rules = {
    container_port_ingress = {
      type        = "ingress"
      from_port   = local.container.port
      to_port     = local.container.port
      protocol    = "tcp"
      description = "Container port access from internet"
      cidr_blocks = ["0.0.0.0/0"]
    }
    prviate_subnet_egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
    }
  }

  tags = module.tags.tags
}
