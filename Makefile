CHART_REPO := http://chartmuseum.thunder.thunder.fabric8.io
NAME := helm-charts
OS := $(shell uname)
RELEASE_VERSION := $(shell semver-release-version)
HELM := $(shell command -v helm 2> /dev/null)
IP := $(shell minikube ip)
setup:
	minikube addons enable ingress
ifndef HELM
ifeq ($(OS),Darwin)
	brew install kubernetes-helm
else
	echo "Please install helm first https://github.com/kubernetes/helm/blob/master/docs/install.md"
endif
endif
	helm init
	helm repo add chartmuseum $(CHART_REPO)
	helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/

build: clean
	rm -rf requirements.lock
	helm dependency build
	helm lint

install: clean build
	helm install . --name fabric8
	watch kubectl get pods

upgrade: clean build
	helm upgrade fabric8 .
	watch kubectl get pods

delete:
	helm delete --purge fabric8
	kubectl delete cm --all
	kubectl delete ing --all

clean:
	rm -rf charts
	rm -rf ${NAME}*.tgz
	helm repo update

release: clean
	helm dependency build
	helm lint
ifeq ($(OS),Darwin)
	sed -i "" -e "s/version:.*/version: $(RELEASE_VERSION)/" Chart.yaml
else ifeq ($(OS),Linux)
	echo "linux"
else
	exit -1
endif
	git add Chart.yaml
	git commit -a -m "release $(RELEASE_VERSION)"
	git tag -fa v$(RELEASE_VERSION) -m "Release version $(RELEASE_VERSION)"
	git push origin v$(RELEASE_VERSION)
	helm package .
	curl --data-binary "@$(NAME)-$(RELEASE_VERSION).tgz" $(CHART_REPO)/api/charts
	rm -rf ${NAME}*.tgz