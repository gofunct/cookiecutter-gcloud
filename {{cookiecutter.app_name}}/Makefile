#  __     __         _       _     _
#  \ \   / /_ _ _ __(_) __ _| |__ | | ___ ___
#   \ \ / / _` | '__| |/ _` | '_ \| |/ _ \ __|
#    \ V / (_| | |  | | (_| | |_) | |  __\__ \
#     \_/ \__,_|_|  |_|\__,_|_.__/|_|\___|___/
#

PROJECT?=$(shell gcloud config list project | awk 'FNR ==2 { print $$3 }')
TAG=gcr.io/$(PROJECT)/server-dev
NAME={{cookiecutter.app_name}}-server-shell
DOCKER_GID=$(word 3,$(subst :, ,$(shell getent group docker)))
PORT=7080

#Directory that this Makefile is in.
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_path := $(dir $(mkfile_path))
project_path := $(realpath $(current_path)/..)
root_path := $(realpath $(project_path)/..)

#   _____                    _
#  |_   _|_ _ _ __ __ _  ___| |_ ___
#    | |/ _` | '__/ _` |/ _ \ __/ __|
#    | | (_| | | | (_| |  __/ |_\__ \
#    |_|\__,_|_|  \__, |\___|\__|___/
#                 |___/

build: ## build the docker dev image
	docker build --tag=$(TAG) $(current_path)

push: ## push docker image
	gcloud docker push $(TAG)

pull: ## pull docker image
	gcloud docker pull $(TAG)

clean: ##clean up the shell
	docker rmi $(TAG)

shell: ## Start a dev shell
	mkdir -p ~/.config/gcloud
	mkdir -p $(project_path)/.kube
	docker run --rm \
		--name=$(NAME) \
		-p=8001:8001 \
		-P=true \
		-e TERM \
		-e HOST_GID=`id -g` \
		-e HOST_UID=`id -u` \
		-e HOST_USER=$(USER) \
		-e DOCKER_GID=$(DOCKER_GID) \
		-v ~/.config/gcloud:/home/$(USER)/.config/gcloud \
		-v ~/.appcfg_oauth2_tokens:/home/$(USER)/.appcfg_oauth2_tokens \
		-v $(project_path)/.kube:/home/$(USER)/.kube \
		-v $(project_path)/dev/zshrc:/home/$(USER)/.zshrc \
		-v /usr/bin/docker:/usr/bin/docker \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(project_path):/home/$(USER)/server \
		-w /home/$(USER)/server \
		-it $(TAG) /root/startup.sh


shell-attach: ## attach to a running dev shell
	docker exec -it --user=$(USER) $(NAME) zsh


mount-go: ## mount the go sdk
	mkdir -p /tmp/$(NAME)/go
	sshfs $(USER)@0.0.0.0:/usr/local/go /tmp/$(NAME)/go -p $(call getPort,22) -o follow_symlinks


chrome: ## open chrome to the forwarded port
	google-chrome http://localhost:$(call getPort,$(PORT))

info: # get info and config from gcloud
	gcloud info
	gcloud config list

help: ## help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
#   _____                 _   _
#  |  ___|   _ _ __   ___| |_(_) ___  _ __  ___
#  | |_ | | | | '_ \ / __| __| |/ _ \| '_ \/ __|
#  |  _|| |_| | | | | (__| |_| | (_) | | | \__ \
#  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
#

# get the mapped docker host port
getPort = $(word 2,$(subst :, ,$(shell docker port $(NAME) $(1))))