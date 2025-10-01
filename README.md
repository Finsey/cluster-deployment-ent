# Integrated Platform Home Lab

Launch a fully automated container orchestration platform (Kubernetes) from empty disk to running services using a single `make` command.

## Overview

The use of this project has been tested using a development server only.

This project utilises Infrastructure as Code[https://en.wikipedia.org/wiki/Infrastructure_as_code] to automate provisioning, operating, and updating self-hosted services for a home lab. It can be used as a highly customisable framework for your own.

## Prerequisites
On the Deployment Appliance (essentially the host from which you are deploying from), ensure that the following are present:
* `ansible-core`
* `openssl`
* `Cloudflared`[https://pkg.cloudflare.com/index.html)]

If you would like for your services to reach the internet, you will have to purchase a domain. I have purchased mine from Cloudflare. Otherwise, you can utilise your own private network with a running `dnsmasq` Docker container to reach these services on your own LAN. 

## Manual Steps
There are a few manual steps that you are required to complete that this repository should not be used for.

### Supplying configuration variables
- Inventory: MAC address, hostnames, etc.
- Domain, etc.

### Generating root certificates
It is suggested to have a good working knowledge of PKI and OpenSSL (including its purpose, folder structure, and so on) when conducting the below steps.

We will be generating a self-signed Root Certificate Authority (CA) and an intermediary from the Root CA.

Securing distributed software requires configuring using SSL (also known as TLS) to encrypt communications:
* Node to node communication
* Client to node communication

Setting up SSL means providing SSL certificates for each node; but generating SSL certificates is a cumbersome task.

There is a requirement to generate your own certificate authority that will be used to sign the certificates of all hosts belonging to our cluster. As this step will only be done once, it has not been automated:

```shell
[insert commands here]
```

Store these variables under `system/group_vars/org_ca/` in the respective folders.

It is highly encouraged to use the Ansible "Vault" feature like so if you plan on storing sensitive secrets within source control:
```
$ ansible-vault encrypt {{ playbook_dir }}/group_vars/org_ca/root.key
New Vault password:
Confirm New Vault password:
Encryption successful
```

### Cloudflared

#### Creating a tunnel and enabling routing
You may create a tunnel via the API or CLI.

To create a tunnel using the CLI:
1. Login to Cloudflared via `cloudflared tunnel login`
2. Create a tunnel via `cloudflared tunnel create {tunnel-name}`. You may retrieve the ID number of the tunnel via `cloudflared tunnel list`.
3. Proceed to enable automatic DNS configuration via `cloudflared tunnel route dns example-tunnel example.com`

#### Preparing tunnel files
##### Step 1: Locate tunnel files
After creating the tunnel, you'll have these files in ~/.cloudflared/:

* `cert.pem` - Certificate file
* `<tunnel-id>.json` - Credentials file

##### Step 2: Encode Files for Helm
Encode the files using base64:

```
# Encode credentials JSON file
base64 -b 0 -i ~/.cloudflared/*.json

# Encode certificate PEM file
base64 -b 0 -i ~/.cloudflared/cert.pem
```

Supply these values into group variables: `system/group_vars/all.yaml`.