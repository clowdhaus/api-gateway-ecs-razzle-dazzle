locals {
  container = {
    name = "dazzle"
    port = 3030
  }
}

################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "github.com/clowdhaus/terraform-aws-ecs//modules/cluster"

  cluster_name = local.name

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {}
  }

  cluster_service_connect_defaults = {
    namespace = aws_service_discovery_private_dns_namespace.this.arn
  }

  tags = module.tags.tags
}

################################################################################
# Service
################################################################################

data "aws_ecr_repository" "this" {
  name = local.name
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "~> 5.0"

  name        = local.name
  cluster_arn = module.ecs_cluster.arn
  launch_type = "FARGATE"

  cpu    = 256
  memory = 512

  # Container definition(s)
  container_definitions = {
    dazzle = {
      essential = true
      # This will barf on initial deploy if image does not yet exist
      image = "${data.aws_ecr_repository.this.repository_url}:v0.2.0"
      port_mappings = [
        {
          name          = local.container.name
          containerPort = local.container.port
          hostPort      = local.container.port
          protocol      = "tcp"
        }
      ]
      health_check = {
        command      = ["CMD", "/app/up --port 3000 --path /healthz || exit 1"]
        interval     = 30
        retries      = 3
        start_period = 10
        timeout      = 5
      }
    }
  }

  service_connect_configuration = {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.this.arn

    service = {
      client_alias = {
        port = local.container.port
      }
      port_name      = local.container.name
      discovery_name = local.container.name
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_rules = {
    api_gateway_ingress = {
      type                     = "ingress"
      from_port                = local.container.port
      to_port                  = local.container.port
      protocol                 = "tcp"
      description              = "API gateway forward to container"
      source_security_group_id = module.api_gateway.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = module.tags.tags
}

################################################################################
# Service Discovery
################################################################################

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = "dazzle.local"
  description = "Private DNS namespace for ${local.name}"
  vpc         = module.vpc.vpc_id

  tags = module.tags.tags
}

data "aws_service_discovery_service" "this" {
  name         = local.container.name
  namespace_id = aws_service_discovery_private_dns_namespace.this.id

  depends_on = [module.ecs_service]
}
