locals {
  create_ecs = true

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

  create       = local.create_ecs
  cluster_name = local.name

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {}
  }

  cluster_service_connect_defaults = {
    namespace = try(aws_service_discovery_private_dns_namespace.this[0].arn, null)
  }

  tags = module.tags.tags
}

################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "github.com/clowdhaus/terraform-aws-ecs//modules/service"

  create = local.create_ecs

  name        = local.name
  cluster_arn = coalesce(module.ecs_cluster.arn, "x")
  launch_type = "FARGATE"

  cpu    = 256
  memory = 512

  # Container definition(s)
  container_definitions = {
    dazzle = {
      essential = true
      # This will barf on initial deploy if image does not yet exist
      image = "${module.ecr.repository_url}:v0.1.1"
      port_mappings = [
        {
          name          = local.container.name
          containerPort = local.container.port
          hostPort      = local.container.port
          protocol      = "tcp"
        }
      ]
    }
  }

  service_connect_configuration = {
    enabled   = true
    namespace = try(aws_service_discovery_private_dns_namespace.this[0].arn, null)

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
    self_ingress_container_port = {
      type                     = "ingress"
      from_port                = local.container.port
      to_port                  = local.container.port
      protocol                 = "tcp"
      description              = "Self ingress container port"
      source_security_group_id = try(aws_security_group.vpc_link[0].id, null)
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
  count = local.create_ecs ? 1 : 0

  name        = "dazzle.local"
  description = "Private DNS namespace for ${local.name}"
  vpc         = module.vpc.vpc_id

  tags = module.tags.tags
}

data "aws_service_discovery_service" "this" {
  name         = local.container.name
  namespace_id = aws_service_discovery_private_dns_namespace.this[0].id

  depends_on = [module.ecs_service]
}
