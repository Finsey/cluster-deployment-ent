.POSIX:

export KUBECONFIG = $(shell pwd)/../metal/kubeconfig.yaml

.PHONY: install
install:
	ansible-playbook \
		install.yaml
