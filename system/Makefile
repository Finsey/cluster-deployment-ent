.POSIX:

export KUBECONFIG = /root/.kube/config
export K8S_AUTH_KUBECONFIG = $(KUBECONFIG)

# .PHONY: install
default: deps install

deps:
	ansible-galaxy collection install \
		-r requirements.yaml

install:
	ansible-playbook \
		install.yaml --extra-vars deploy_action=install
