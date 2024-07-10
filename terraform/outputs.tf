output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "backend_service_ip" {
  value = kubernetes_service.backend.status[0].load_balancer[0].ingress[0].ip
}

output "frontend_service_ip" {
  value = kubernetes_service.frontend.status[0].load_balancer[0].ingress[0].ip
}
