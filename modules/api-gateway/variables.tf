variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to API gateway resources"
  type        = map(string)
  default     = {}
}

################################################################################
# API Gateway
################################################################################

variable "api_key_selection_expression" {
  description = "An API key selection expression. Valid values: `$context.authorizer.usageIdentifierKey`, `$request.header.x-api-key`. Defaults to `$request.header.x-api-key`. Applicable for WebSocket APIs"
  type        = string
  default     = null
}

variable "cors_configuration" {
  description = "The cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs"
  type        = any
  default     = {}
}

variable "credentials_arn" {
  description = "Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the API. Must be less than or equal to 1024 characters in length"
  type        = string
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "Whether clients can invoke the API by using the default execute-api endpoint. By default, clients can invoke the API with the default `{api_id}.execute-api.{region}.amazonaws.com endpoint`. To require that clients use a custom domain name to invoke the API, disable the default endpoint"
  type        = bool
  default     = null
}

variable "fail_on_warnings" {
  description = "Whether warnings should return an error while API Gateway is creating or updating the resource using an OpenAPI specification. Defaults to `false`. Applicable for HTTP APIs"
  type        = bool
  default     = null
}

variable "name" {
  description = "The name of the API. Must be less than or equal to 128 characters in length"
  type        = string
  default     = ""
}

variable "body" {
  description = "An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs"
  type        = string
  default     = null
}

variable "protocol_type" {
  description = "The API protocol. Valid values: `HTTP`, `WEBSOCKET`"
  type        = string
  default     = "HTTP"
}

variable "route_key" {
  description = "Part of quick create. Specifies any route key. Applicable for HTTP APIs"
  type        = string
  default     = null
}

variable "route_selection_expression" {
  description = "The route selection expression for the API. Defaults to `$request.method $request.path`"
  type        = string
  default     = null
}

variable "target" {
  description = "Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP_PROXY or AWS_PROXY, respectively. Applicable for HTTP APIs"
  type        = string
  default     = null
}

variable "api_version" {
  description = "A version identifier for the API. Must be between 1 and 64 characters in length"
  type        = string
  default     = null
}

variable "api_mapping_key" {
  description = "The [API mapping key](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-mapping-template-reference.html)"
  type        = string
  default     = null
}

################################################################################
# Authorizer(s)
################################################################################

variable "authorizers" {
  description = "Map of API gateway authorizers to create"
  type        = any
  default     = {}
}

################################################################################
# Domain Name
################################################################################

variable "create_domain_name" {
  description = "Whether to create API domain name resource"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "The domain name to use for API gateway"
  type        = string
  default     = null
}

variable "domain_name_certificate_arn" {
  description = "The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name. AWS Certificate Manager is the only supported source"
  type        = string
  default     = null
}

variable "domain_name_ownership_verification_certificate_arn" {
  description = "ARN of the AWS-issued certificate used to validate custom domain ownership (when certificate_arn is issued via an ACM Private CA or mutual_tls_authentication is configured with an ACM-imported certificate.)"
  type        = string
  default     = null
}

variable "mutual_tls_authentication" {
  description = "The mutual TLS authentication configuration for the domain name"
  type        = map(string)
  default     = {}
}

################################################################################
# Integration(s)
################################################################################

variable "create_routes_and_integrations" {
  description = "Whether to create routes and integrations resources"
  type        = bool
  default     = true
}

variable "integrations" {
  description = "Map of API gateway routes with integrations"
  type        = any
  default     = {}
}

################################################################################
# Stage
################################################################################

variable "create_stage" {
  description = "Whether to create default stage"
  type        = bool
  default     = true
}

variable "stage_access_log_settings" {
  description = "Settings for logging access in this stage. Use the aws_api_gateway_account resource to configure [permissions for CloudWatch Logging](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#set-up-access-logging-permissions)"
  type        = any
  default = {
    format = {
      "requestId"               = "$context.requestId",
      "requestTime"             = "$context.requestTime",
      "httpMethod"              = "$context.httpMethod",
      "routeKey"                = "$context.routeKey",
      "stage"                   = "$context.stage",
      "status"                  = "$context.status",
      "protocol"                = "$context.protocol",
      "errorMessage"            = "$context.error.message",
      "errorResponseType"       = "$context.error.responseType",
      "sourceIp"                = "$context.identity.sourceIp",
      "userAgent"               = "$context.identity.userAgent",
      "integrationError"        = "$context.integration.error",
      "integrationStatus"       = "$context.integration.integrationStatus",
      "integrationLatency"      = "$context.integration.latency",
      "integrationRequestId"    = "$context.integration.requestId",
      "integrationStatus"       = "$context.integration.status",
      "integrationErrorMessage" = "$context.integrationErrorMessage",
    }
  }
}

variable "stage_client_certificate_id" {
  description = "The identifier of a client certificate for the stage. Use the `aws_api_gateway_client_certificate` resource to configure a client certificate. Supported only for WebSocket APIs"
  type        = string
  default     = null
}

variable "stage_default_route_settings" {
  description = "The default route settings for the stage"
  type        = map(string)
  default = {
    throttling_burst_limit = 500
    throttling_rate_limit  = 1000
  }
}

variable "stage_description" {
  description = "The description for the stage. Must be less than or equal to 1024 characters in length"
  type        = string
  default     = null
}

variable "stage_name" {
  description = "The name of the stage. Must be between 1 and 128 characters in length"
  type        = string
  default     = "$default"
}

variable "stage_variables" {
  description = "A map that defines the stage variables for the stage"
  type        = map(string)
  default     = {}
}

variable "stage_tags" {
  description = "A mapping of tags to assign to the stage resource"
  type        = map(string)
  default     = {}
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 14
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

################################################################################
# VPC Link
################################################################################

variable "vpc_links" {
  description = "Map of VPC Link definitions to create"
  type        = any
  default     = {}
}

variable "vpc_link_tags" {
  description = "A map of tags to add to the VPC Links created"
  type        = map(string)
  default     = {}
}

################################################################################
# Security Group
################################################################################

variable "create_security_group" {
  description = "Determines if a security group is created"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}

variable "security_group_use_name_prefix" {
  description = "Determines whether the security group name (`security_group_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "security_group_description" {
  description = "Description of the security group created"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {}
}

variable "security_group_tags" {
  description = "A map of additional tags to add to the security group created"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
  default     = null
}
