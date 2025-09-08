## Project Setup (Recommended)

To prepare your environment for development, simply run:

```shell
make setup
```
This will automatically:
- Install the Root CA certificate for HTTPS (MacOS or Linux)
- Add all required DNS entries from the project's hosts file to your `/etc/hosts`

You will be prompted for your administrator password (sudo) if necessary.

<details>
<summary>Manual Setup (Advanced)</summary>

## Manual Setup (Advanced)

If you need to run steps individually, use the following commands:

### Add DNS lookup to /etc/hosts
```shell
make apply-hosts
```
Checks each entry in the project's `hosts` file and adds only those missing to `/etc/hosts`.

### Install Root CA
```shell
make install-root-ca
```
Installs the Root CA certificate for HTTPS. For MacOS, uses the `security` command. For Linux, copies the certificate and runs `update-ca-certificates`. For other systems, follow manual instructions.
</details>

## Adding CA cert into Chrome on Linux
Chrome on Linux doesn't get the CA certificate from the OS global repository.
To add it manually follow the following instructions:

1. Go to Chrome Settings/Privacy and Security
2. Click Security and scroll down to "Manage Certificates"
3. In Local Certificates, click Custom and next to Trusted Certificates click Import
4. Import `/traefik/certs/ca/rootCA.crt`

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

### Synapse initial users
Synapse will spin up with an administrator user configured with username `admin` and password `admin`

### .env file
It's possible to copy the `.env.example` to `.env` and include the certificates and matrix signing key to
configure the services on startup.

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