# Kinda Kind

This is a local kubernetes env setup. This is for testing purposes and learning.
This repo will deploy a kind (kubernetes-in-docker) cluster and install tooling to make it a bit
more user friendly. Terraform will provision the tooling using the helm and kubernetes terraform providers.

## Prereqs

- [Docker](https://www.docker.com/)
- [Terraform](https://developer.hashicorp.com/terraform)
- [Kind](https://kind.sigs.k8s.io/) (Kubernetes-in-docker)
- DNS Provider or access to `/etc/hosts` on your local machine

## Setup

1. Run the `install.sh` script to install kind or install it how you want to
2. Create a `config.tfvars` file and add the variables from the `variables.tf`
3. Update dns for services deployed with this automation
   1. Update `/etc/hosts` with the domain name and local ip address or update your DNS provider with a wildcard record for your local ip address
   2. DNS/Services include
      1. grafana.<domain_name>
      2. prometheus.<domain_name>
      3. opencost.<domain_name>
      4. dashboard.<domain_name>
   3. These domain names must resolve to the machine running this kind/terraform automation
4. Everything is driven by the `Makefile` so you can run `make deploy` to deploy everything

## Afterwards

In this example, my `wildcard_domain_name` is `kind.domain.net`. In my `/etc/hosts` file, I added a line
with my `IP address` then `*.kind.domain.net`

You should be presented with terraform outputs with info

```sh
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

dashboard = {
  "dashboard_url" = "http://dashboard.kind.domain.net"
  "get_token_cmd" = "kubectl -n kubernetes-dashboard create token admin-user"
}
monitoring_urls = {
  "default_grafana_login" = {
    "password" = "prom-operator"
    "username" = "admin"
  }
  "grafana_url" = "http://grafana.kind.domain.net"
  "prometheus_url" = "http://prometheus.kind.domain.net"
}
opencost_url = "opencost.kind.domain.net"
```

To get a cluster dashboard you can run the `get_token_cmd` on your kind cluster then input the token
in your `dashboard_url`.

To check the cluster health and other metric information, you can login to grafana and/or prometheus using the urls
and credentials shown in the outputs.

To check the cost of all the resources that are deployed, you can use the `opencost` application that
provides an estimate of on-prem and/or cloud resource cost. The `opencost_url` will provide a dashboard to
provide cost related information.

### Stress test for cost

To stress test the cluster, use this unfinished stress yaml manifest

```sh
kubectl apply -f helm/opencost/stress.yaml
```

## Teardown

Everything is driven by `make` which is located in the `Makefile`.

```sh
make destroy
```

TODO: add metrics server https://gist.github.com/sanketsudake/a089e691286bf2189bfedf295222bd43
