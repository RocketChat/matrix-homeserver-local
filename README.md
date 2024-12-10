## Clone the homeserver repo to the parent directory

```shell
git clone https://github.com/RocketChat/homeserver ../homeserver
```

## Run docker compose

```shell
docker compose up --build
```

## Creating initial users via command line

### HomeServers (Synapse)

```shell
docker exec -it hs1 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml
docker exec -it hs2 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml
```

## Add DNS lookup to /etc/hosts

```
sudo tee -a /etc/hosts <<EOF
127.0.0.1       hs1
127.0.0.1       hs2
127.0.0.1       rc1
EOF
```

## Install Root CA

### MacOS

```shell
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain traefik/certs/ca/rootCA.crt
```

### WSL2 or Linux

Source: https://dkm10.hashnode.dev/install-certificates-on-wsl2

```shell
/usr/local/share/ca-certificates
sudo update-ca-certificates
```

## Accessing Element

Go to http://localhost:8080
