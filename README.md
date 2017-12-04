# Platform Helm Chart

Jenkins + Sonartype Nexus 3.x

## Local development

Best way to get started is with minikube.  

This repo has some helper commands to get you started

```
git clone https://github.com/ronmaclean/helm-charts && cd helm-charts
minikube start --vm-driver xhyve
```
We use `helm` as the package manager and install / upgrade features so to get the binary and install an nginx ingress controller so we can access our apps run:
```
make setup
```
to install on minikube:
```
make install
```
now you can edit charts and apply the chages using:
```
make upgrade
```
to clean up run:
```
make delete
```

## Install on remote cluster

WIP

## Accessing applications

You can list the external URLs used to acess applications on you kubernetes cluster by running:
```
kubectl get ingress
```

## Credentials

This repo is for test purposes so default admin username and passwords are used:

| Application | Username | Password |
| ----------- |:--------:| --------:|
| Jenkins     | admin    | admin    |
| Nexus       | admin    | admin123 |