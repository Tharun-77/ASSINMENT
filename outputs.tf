output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.ecs_cluster_arn
}

output "instructions_to_verify_work_pool" {
  description = "Instructions to verify the work pool in Prefect Cloud"
  value       = <<EOT

        Go to Prefect Cloud → Work Pools
        Check if the work pool named 'ecs-work-pool' exists.
        Ensure it is associated with the correct infrastructure block.
        Make sure the ECS worker is in a healthy state and polling.

EOT
}