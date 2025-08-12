.POSIX:

env ?= prod
export KUBECONFIG = /root/.kube/config

default: deps boot cluster

~/.ssh/id_ed25519:
	ssh-keygen -t ed25519 -P '' -f "$@"

deps:
	ansible-galaxy collection install \
		-r requirements.yaml

boot: ~/.ssh/id_ed25519
	ansible-playbook \
		--inventory inventories/${env}.yaml \
		boot.yaml

cluster:
	ansible-playbook \
		--inventory inventories/${env}.yaml \
		cluster.yaml

console:
	ansible-console \
		--inventory inventories/${env}.yaml
