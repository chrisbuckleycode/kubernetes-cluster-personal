resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [kubernetes_namespace.ingress_nginx]

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.5.2"

  values = [
    "${file("manifests/nginx-values-v4.1.3.yaml")}"
  ]
    timeout = 600    # DO load balancers may take a while to spin up
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"

  # among other things, install requisite CRDs automatically
  values = [
    "${file("manifests/cert-manager-values-v1.8.0.yaml")}"
  ]

  timeout = 600

  depends_on = [helm_release.ingress_nginx]
}
