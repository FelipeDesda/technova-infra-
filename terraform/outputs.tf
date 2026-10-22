output "registry_vpc_id" {
  description = "VPC ID do módulo Registry"
  value       = module.vpc_registry.vpc_id
}

output "registry_public_subnets" {
  description = "Subnets públicas do módulo Registry"
  value       = module.vpc_registry.public_subnets
}

output "registry_private_subnets" {
  description = "Subnets privadas do módulo Registry"
  value       = module.vpc_registry.private_subnets
}