.POSIX:

export KUBECONFIG = $(shell pwd)/../metal/kubeconfig.yaml

# .PHONY: install
default: deps install

deps:
	ansible-galaxy collection install \
		-r requirements.yaml

install:
	ansible-playbook \
		install.yaml
