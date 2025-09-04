## Run docker compose

The compose runs only synapse and element by default, so you can run rocket.chat via localhost development mode:
```shell
docker compose up
```

By passing the profile flag you can spin up a rocket.chat container included
```shell
docker compose --profile rc1 up
```

By passing the profile `all` it will spin up 2 rocket.chat instances and a second synapse `hs2`
```shell
docker compose --profile all up
```

### Profiles
- rc1 -> Spins up traefik, element, hs1 and rc1
- rc2 -> Spins up traefik, element, hs1 and rc2
- hs2 -> Spins up traefik, element, hs1 and hs2
- all -> Spins up traefik, element, hs1, hs2, rc1 and rc2

Multiples profiles can be passed like
```shell
docker compose --profile rc1 --profile hs2 up
```

### Rocket.Chat initial users
Rocket.Chat will spin up with an administrator user configured with username `admin` and password `admin`

### .env file
It's possible to copy the `.env.example` to `.env` and include the certificates and matrix signing key to
configure the services on startup.

## Creating initial users via command line

### HomeServers (Synapse)

```shell
docker exec -it hs1 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml
docker exec -it hs2 register_new_matrix_user -u admin -p admin --admin http://localhost:8008 -c /data/homeserver.yaml
```

## Add DNS lookup to /etc/hosts

To ensure that the domains used in the project are present in your machine's `/etc/hosts` file, run:

```shell
make apply-hosts
```
This command will check each entry in the project's `hosts` file and add to `/etc/hosts` only those that are missing.
You will need to provide your administrator password (sudo).

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
export NODE_EXTRA_CA_CERTS="$(PWD)/traefik/certs/ca/rootCA.crt"
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

## Cleaning up all data from containers

```shell
make clean-all
```

Or use `make` to see other commands