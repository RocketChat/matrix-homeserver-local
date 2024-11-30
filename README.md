## Accessing Element
	http://localhost:8080

## Creating users via command line
	Synapse1
	`docker exec -it synapse1_a register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml`

	Synapse2
	`docker exec -it synapse2_a register_new_matrix_user http://localhost:8008 -c /data/homeserver.yaml`

## Root CA
	The root CA at `traefik/certs/ca/rootCA.crt` should be installed as system's  Root CA

### MacOS
	1. Double click the crt file
	2. Double click the installed certificate in Keychain Access and change to `Always Trust`

### WSL2 or Linux
	https://dkm10.hashnode.dev/install-certificates-on-wsl2
	`/usr/local/share/ca-certificates`
	`sudo update-ca-certificates`
