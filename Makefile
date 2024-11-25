deploy: deploy-cluster apply-terraform

destroy: clean destroy-cluster

deploy-cluster:
	kind create cluster --config config.yaml

destroy-cluster:
	kind delete cluster

clean:
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup


setup-ingress:
	kubectl apply -f https://kind.sigs.k8s.iodocker/examples/ingress/deploy-ingress-nginx.yaml
		watch -n 2 "kubectl get pods --namespace ingress-nginx"

plan-terraform:
	terraform init
	terraform plan -var-file config.tfvars

apply-terraform:
	terraform init
	terraform apply -auto-approve -var-file config.tfvars

destroy-terraform:
	terraform destroy -auto-approve -var-file config.tfvars

setup-spark:
	helm repo add spark-operator https://kubeflow.github.io/spark-operator
	helm install spark-operator spark-operator/spark-operator \
        --namespace spark-operator \
        --create-namespace \
        --set webhook.enable=true
	watch -n 2 "kubectl get all -n spark-operator"

run-spark-pi:
	kubectl apply -f ./spark/pi-spark.yaml
	watch -n 2 "kubectl get sparkapp"