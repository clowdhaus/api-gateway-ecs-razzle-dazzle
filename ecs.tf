locals {
  create_ecs = false

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

  cpu    = 256
  memory = 512

  # Container definition(s)
  container_definitions = {
    dazzle = {
      essential = true
      # This will barf on initial deploy
      image = "${module.ecr.repository_url}:v0.1.0"
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

  service_registries = {
    # container_name = local.container.name
    # container_port = local.container.port
    port         = local.container.port
    registry_arn = try(aws_service_discovery_service.this[0].arn, null)
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
    # all = {
    #   type        = "ingress"
    #   from_port   = -1
    #   to_port     = -1
    #   protocol    = -1
    #   source_sec
    # }
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

resource "aws_service_discovery_service" "this" {
  count = local.create_ecs ? 1 : 0

  name = "dazzle"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.this[0].id

    dns_records {
      ttl  = 60
      type = "SRV"
    }
  }

  # health_check_custom_config {
  #   failure_threshold = 1
  # }

  tags = module.tags.tags
}
