# dcos-commons nginx TLS

This is a helper docker container image running an nginx server with
`keystore-https.hello-world.l4lb.thisdcos.directory` name. The container is
used within `dcos-commons` integration test suite.

The `nginx` is configured to expose an HTTP webserver on port `80` which
redirects requests to the port `443` with TLS. The container
expects a certificate and a private key to be available in `/opt` directory
on a container start.

## Build

Build a container locally

```sh
make build
```

Push a container to docker registry

```sh
make push
```

By default the container is being pushed to the `mesosphere` docker hub
namespace. It is possible to build and push a container to custom namespace,
container name and version.

```
make push NS=mhrabovcin NAME=my-nginx VERSION=0.1
```

## Run

The `nginx` configuration depends on `/opt/site.key` and `/opt/site.crt` files
to be provided to the container. Files can be mounted with `-v` flag. Without
these files container will fail with following message:

```
2017/07/13 11:35:44 [emerg] 1#1: BIO_new_file("/opt/site.crt") failed (SSL: error:02001002:system library:fopen:No such file or directory:fopen('/opt/site.crt','r') error:2006D080:BIO routines:BIO_new_file:no such file)
nginx: [emerg] BIO_new_file("/opt/site.crt") failed (SSL: error:02001002:system library:fopen:No such file or directory:fopen('/opt/site.crt','r') error:2006D080:BIO routines:BIO_new_file:no such file)
```
