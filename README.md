## Run docker compose

```shell
docker compose up
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
127.0.0.1       element
127.0.0.1       hs1
127.0.0.1       hs2
127.0.0.1       rc1
127.0.0.1       rc.host
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

Go to https://element

## Running Rocket.Chat locally

While [use system CA](https://github.com/nodejs/node/issues/58990) for MacOS is not supported on NodeJS, it's
necessary to manually point it to the extra certificate:

```shell
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
```

Then it's possible to access it via `https://rc.host` which points to the host's machine port 3000

## Generating new certificates

On MacOS use [mkcert](https://github.com/FiloSottile/mkcert)

```shell
brew install mkcert
mkcert -install
cd traefik/certs
mkcert newdomain
```