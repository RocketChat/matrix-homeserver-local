## Clone the homeserver repo to the parent directory

	git clone https://github.com/ggazzo/homeserver.git ../homeserver

## Creating users via command line

### Synapse1

	docker exec -it synapse1 register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml

### Synapse2
	docker exec -it synapse2 register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml

## Add to /etc/hosts

	127.0.0.1       synapse1
	127.0.0.1       synapse2

## Root CA

The root CA at `traefik/certs/ca/rootCA.crt` should be installed as system's  Root CA

### MacOS

1. Double click the crt file
2. Double click the installed certificate in Keychain Access and change to `Always Trust`

### WSL2 or Linux

Source: https://dkm10.hashnode.dev/install-certificates-on-wsl2

	/usr/local/share/ca-certificates
	sudo update-ca-certificates

## Accessing Element

Go to http://localhost:8080.
