terraform {
  required_version = "~> 1.2.9"

  required_providers {
    helm     = "~> 2.9"
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
# If API errors on apply, use instead: export KUBE_CONFIG_PATH=~/.kube/config
}
