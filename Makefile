.PHONY: gen help

gen: ## generate the project
	cookiecutter --no-input -v https://github.com/gofunct/cookiecutter-k8s.git

help: ## help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort