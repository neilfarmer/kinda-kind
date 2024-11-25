# Kinda Kind

This is a local kubernetes env setup. This is for testing purposes and learning.

## Setup

1. Run the install.sh script to install kind or install it how you want to
2. Create a `config.yaml` file and add the variables from the `variables.tf`
3. Run `make deploy`

## Stress test for cost

kubectl create namespace stress
kubectl create -n stress -f stress.yaml
kubectl delete -n stress -f stress.yaml

TODO: add metrics server https://gist.github.com/sanketsudake/a089e691286bf2189bfedf295222bd43
