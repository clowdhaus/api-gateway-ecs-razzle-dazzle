output "api_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.api_gateway.stage_invoke_url
}
