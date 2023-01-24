resource "digitalocean_kubernetes_cluster" "cluster1" {
  name         = "cluster1"
  region       = "ams3"
  auto_upgrade = false
  # surge_upgrade = false
  # above parameter won't apply = BUG!
  ha = false
  
  # Grab the latest version slug from `doctl kubernetes options versions`
  version      = "1.25.4-do.0"

  node_pool {
    name       = "pool1"
    size       = "s-1vcpu-2gb"
    node_count = 1
    auto_scale = false
  }
}
