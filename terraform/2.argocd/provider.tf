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


# For future use
/*
  # localhost registry with password protection
  registry {
    url = "oci://localhost:5000"
    username = "username"
    password = "password"
  }

  # private registry
  registry {
    url = "oci://private.registry"
    username = "username"
    password = "password"
  }
*/

}
