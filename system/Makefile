.POSIX:

KUBECONFIG = /root/.kube/config
KUBE_CONFIG_PATH = $(KUBECONFIG)
K8S_AUTH_KUBECONFIG = $(KUBECONFIG)

# .PHONY: install
default: deps install

deps:
	ansible-galaxy collection install \
		-r requirements.yaml

install:
	ansible-playbook \
		install.yaml --extra-vars deploy_action=install
