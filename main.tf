locals {
  wildcard_domain_name = var.wildcard_domain_name
}

resource "null_resource" "apply_ingress_manifest" {
  provisioner "local-exec" {
    command = <<EOT
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
    EOT
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f deploy.yaml || true"
  }
}

resource "null_resource" "wait_for_ingress_deployment" {
  depends_on = [null_resource.apply_ingress_manifest]

  provisioner "local-exec" {
    command = <<EOT
    kubectl -n ingress-nginx rollout status deployment ingress-nginx-controller
    EOT
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.15.2"

  values     = [templatefile("${path.module}/helm/cert-manager/values.yaml", {})]

  depends_on = [ null_resource.wait_for_ingress_deployment ]
}

resource "helm_release" "dashboard" {
  name       = "kubernetes-dashboard"

  repository = "https://kubernetes.github.io/dashboard/"
  chart      = "kubernetes-dashboard"
  version    = "7.10.0"
  namespace  = "kubernetes-dashboard" 
  create_namespace = true
  values     = [templatefile("${path.module}/helm/dashboard/values.yaml", {
    WILDCARD_DOMAIN_NAME = local.wildcard_domain_name
  })]

  depends_on = [ helm_release.cert_manager ]
}

resource "kubernetes_manifest" "dashboard_service_account" {
  manifest = yamldecode(file("${path.module}/helm/dashboard/service-account.yaml"))
  depends_on = [ helm_release.dashboard ]
}

resource "kubernetes_manifest" "dashboard_service_account_binding" {
  manifest = yamldecode(file("${path.module}/helm/dashboard/cluster-role-binding.yaml"))
  depends_on = [ kubernetes_manifest.dashboard_service_account ]
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "66.2.2"
  create_namespace = true
  values = [templatefile("${path.module}/helm/kube-prometheus/values.yaml", {
    WILDCARD_DOMAIN_NAME = local.wildcard_domain_name
  })]
  depends_on = [ null_resource.wait_for_ingress_deployment ]
}

resource "helm_release" "opencost" {
  name       = "opencost"
  repository = "https://opencost.github.io/opencost-helm-chart"
  chart      = "opencost"
  version    = "1.42.3"
  namespace  = "opencost"
  create_namespace = true
  values = [templatefile("${path.module}/helm/opencost/values.yaml", {
    WILDCARD_DOMAIN_NAME = local.wildcard_domain_name
  })]
  depends_on = [ null_resource.wait_for_ingress_deployment ]
}