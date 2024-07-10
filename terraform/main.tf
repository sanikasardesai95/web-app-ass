provider "google" {
  project = var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://34.27.169.247:443"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "google_container_cluster" "primary" {
  name               = "my-gke-cluster"
  location           = var.region
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50 
  }
  deletion_protection = false
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "example-namespace"
  }
}

resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "backend-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name  = "backend"
          image = var.backend_image
          port {
            container_port = 5000
          }
          env {
            name  = "PGHOST"
            value = "34.172.193.0"
          }
          env {
            name  = "PGDATABASE"
            value = "ica2"
          }
          env {
            name  = "PGUSER"
            value = "postgres"
          }
          env {
            name  = "PGPASSWORD"
            value = "Sanika@"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "frontend-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "frontend"
        }
      }
      spec {
        container {
          name  = "frontend"
          image = var.frontend_image
          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "backend-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      protocol = "TCP"
      port     = 5000
      target_port = 5000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "frontend-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      protocol = "TCP"
      port     = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
