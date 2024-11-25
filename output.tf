output "monitoring_urls" {
  value = {
    grafana_url = "http://grafana.${local.wildcard_domain_name}"
    default_grafana_login = {
      username = "admin"
      password = "prom-operator"
    }
    prometheus_url = "http://prometheus.${local.wildcard_domain_name}"
  }
}

output "opencost_url" {
  value = "opencost.${local.wildcard_domain_name}"
}

output "dashboard" {
  value = {
    dashboard_url = "http://dashboard.${local.wildcard_domain_name}"
    get_token_cmd = "kubectl -n kubernetes-dashboard create token admin-user"
  }
}
