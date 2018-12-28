#  __     __         _       _     _
#  \ \   / /_ _ _ __(_) __ _| |__ | | ___ ___
#   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \ __|
#    \ V / (_| | |  | | (_| | |_) | |  __\__ \
#     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___|___/
#

NAME={{cookiecutter.app_name}}-server
ZONE=u{{cookiecutter.zone}}

#   _____                    _
#  |_   _|_ _ _ __ __ _  ___| |_ ___
#    | |/ _` | '__/ _` |/ _ \ __/ __|
#    | | (_| | | | (_| |  __/ |_\__ \
#    |_|\__,_|_|  \__, |\___|\__|___/
#                 |___/

deploy: ## Create kubernetes cluster
	gcloud deployment-manager deployments create $(NAME) --config cluster.yml

clean: ## Deletes entire deployment
	gcloud deployment-manager deployments delete $(NAME)

auth: ## Sets up the auth for kubectl k8s on the given cluster
	gcloud config set container/cluster $(NAME)
	gcloud config set compute/zone $(ZONE)
	gcloud container clusters get-credentials $(NAME)