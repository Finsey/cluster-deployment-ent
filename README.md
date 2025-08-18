# Integrated Platform

Launch a container orchestration platform (Kubernetes) using a single `make` command.

## Overview

The use of this project has been tested using a development server, without the use of a formal network switch.

## Prerequisites
On the Deployment Appliance, ensure that the following are present:
* `ansible-core`
* `openssl`

## Enable TLS

Securing distributed software requires configuring using SSL (also known as TLS) to encrypt communications:
* Node to node communication
* Client to node communication

Setting up SSL means providing SSL certificates for each node; but generating SSL certificates is a cumbersome task.

There is a requirement to generate your own certificate authority that will be used to sign the certificates of all hosts belonging to our cluster. As this step will only be done once, it has not been automated:

```shell
# On the control host, create or navigate to a securely-held directory accessible only by your user.

$ mkdir {{ playbook_dir }}/group_vars/org_ca
$ cd {{ playbook_dir }}/group_vars/org_ca
$ openssl req -new -x509 \
    -days 3650 \ # (1)
    -extensions v3_ca \ # (2)
    -keyout {{ playbook_dir }}/group_vars/org_ca/root.key -out {{ playbook_dir }}/group_vars/org_ca/root.crt # (3)

Generating a RSA private key
......+++++
....+++++
writing new private key to '{{ playbook_dir }}/group_vars/org_ca/root.key'
Enter PEM pass phrase: # (4)
Verifying - Enter PEM pass phrase:
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:UK # (5)
State or Province Name (full name) [Some-State]:.
Locality Name (eg, city) []:.
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Org-Name
Organizational Unit Name (eg, section) []:.
Common Name (e.g. server FQDN or YOUR name) []:example.local
Email Address []:rootca@example.local
```

1. The CA root certificate will last ten years
2. This certificate will be used as a CA
3. Generate both key and self-signed certificate
4. The key is protected with a password
5. Information describing the Root certificate.

Hold the generated key in secret and store in a secure place:
- It must not be transferred to target servers;
- It must not be kept in source control (Git) unless hidden in an Ansible Vault password file.

You may wish to use the Ansible "Vault" feature like so:
```
$ ansible-vault encrypt {{ playbook_dir }}/group_vars/org_ca/root.key
New Vault password:
Confirm New Vault password:
Encryption successful
```