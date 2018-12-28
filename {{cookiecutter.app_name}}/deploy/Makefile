#  __     __         _       _     _
#  \ \   / /_ _ _ __(_) __ _| |__ | | ___ ___
#   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \ __|
#    \ V / (_| | |  | | (_| | |_) | |  __\__ \
#     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___|___/
#

PROJECT=$(shell gcloud config list project | awk 'FNR ==2 { print $$3 }')
RESIZE=10

#   _____                    _
#  |_   _|_ _ _ __ __ _  ___| |_ ___
#    | |/ _` | '__/ _` |/ _ \ __/ __|
#    | | (_| | | | (_| |  __/ |_\__ \
#    |_|\__,_|_|  \__, |\___|\__|___/
#                 |___/

create-redis: redis-rs redis-service # Deploy redis

redis-rs:
	kubectl apply -f redis-rs.yaml --record

redis-service:
	kubectl create -f redis-service.yaml

create-server: server-rs server-service ## create the server

server-rs: ## replica set for the service
	@cp {{cookiecutter.app_name}}-rs.yaml /tmp/
	@sed -i 's/$${PROJECT}/$(PROJECT)/g' {{cookiecutter.app_name}}-rs.yaml
	kubectl apply -f {{cookiecutter.app_name}}-rs.yaml --record
	@cp /tmp/{{cookiecutter.app_name}}-rs.yaml .

server-service: ## service replica controllers
	kubectl create -f {{cookiecutter.app_name}}-service.yaml

server-resize: ## resize the go server cluster to 10
		kubectl scale deployment {{cookiecutter.app_name}} --replicas=$(RESIZE)

visualise: ## run the visualiser
		kubectl proxy --www=/home/$(shell whoami)/gcp-live-k8s-visualizer --www-prefix=/static/ --api-prefix=/api/ --address="0.0.0.0"

restart: ## clear all the pods, and download them all again from the registry
	kubectl delete pods --all

restart-server: ## just re-deploy the server containers
	kubectl delete pods -l role={{cookiecutter.app_name}}-server

clean:
	kubectl delete deployments --all
	kubectl delete svc --all

help: ## help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort