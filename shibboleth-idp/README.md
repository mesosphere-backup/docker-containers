# Shibboleth IdP 3

This is a reference implementation of the
[Shibboleth IdP](https://wiki.shibboleth.net/confluence/display/IDP30/Home)
provider that can be used as a SAML2 identity provider for the Mesosphere
Enterprise DC/OS.

**IMPORTANT:**
This is an insecure version of the Shibboleth installation as it includes
private encryption, signing and a browser key and **should never** be used
in production.

## DC/OS specifics

This section describes some specifics of Shibboleth IdP configuration that
have to be adjusted and tuned in order to get Shibboleth instance working
with DC/OS.

* LDAP and FreeIPA

  Shibboleth IdP depends on external database for checking identity and also
  optionally for fetching additional attributes that should be released to
  the `RelyingParty`.

  This example configuration uses FreeIPA as a LDAP provider for confirming
  identity credentials and also for fetching additional attributes.

  See files:

  * `shibboleth-idp/conf/ldap.properties`
  * `shibboleth-idp/conf/attribute-resolver.xml`

* Saml NameID generation

  DC/OS SAML connector asks identity provider for persistent Subject NameID
  in `urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress` Format.

  Shibboleth default configuration provides only transient NameID values.
  In order to get Shibboleth working with DC/OS its necessary to update
  NameID generation configuration.

  See files:

  * `shibboleth-idp/conf/saml-nameid.xml`
  * `shibboleth-idp/conf/saml-nameid.properties`
  * `shibboleth-idp/conf/attribute-resolver.xml`

  Other SAML providers usually try to fullfil SAML request by matching
  requested NameID Format and if its not possible to do so they still
  return SAML identity with default NameID Format.

  Shibboleth behaves differently and rejects SAML request if it
  [can't respond](http://shibboleth.net/pipermail/users/2015-June/022101.html)
  with requested NameID format.

* RelyingParty

  DC/OS doesn't support `encryptedAssertions` so its necessary to override turn
  off encryptedAssertions for at least DC/OS RelyingParty.

  See files:

  * `shibboleth-idp/conf/relying-party.xml`

* Single `signing` key in idp-metadata.xml file

  DC/OS underlying SAML library that processes SAML requests reads only first
  `signing` key from providers metadata file. Its recommended to use only
  single key in your provider configuration or make sure that first `signing`
  key is used for signing SAML responses.

## Usage

Build a container

```sh
make build NS=mesosphere
```

Push to the [Docker hub](https://hub.docker.com/)

```sh
make push NS=mesosphere
```

## DC/OS configuration

```json
{
  "id": "/shibboleth",
  "instances": 1,
  "cpus": 1,
  "mem": 1024,
  "disk": 0,
  "gpus": 0,
  "backoffSeconds": 1,
  "backoffFactor": 1.15,
  "maxLaunchDelaySeconds": 3600,
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "mesosphere/shibboleth-idp:latest",
      "network": "HOST",
      "privileged": true,
      "parameters": [
        {
          "key": "hostname",
          "value": "shibboleth.marathon.l4lb.thisdcos.directory"
        }
      ],
      "forcePullImage": true
    }
  },
  "healthChecks": [
    {
      "gracePeriodSeconds": 900,
      "intervalSeconds": 10,
      "timeoutSeconds": 10,
      "maxConsecutiveFailures": 1,
      "protocol": "COMMAND",
      "command": {
        "value": "curl -fks -o /dev/null https://shibboleth.marathon.l4lb.thisdcos.directory:4443/idp/shibboleth"
      }
    }
  ],
  "upgradeStrategy": {
    "minimumHealthCapacity": 1,
    "maximumOverCapacity": 1
  },
  "unreachableStrategy": {
    "inactiveAfterSeconds": 900,
    "expungeAfterSeconds": 604800
  },
  "portDefinitions": [
    {
      "name": "http",
      "port": 4443,
      "protocol": "tcp",
      "labels": {
        "VIP_0": "/shibboleth:4443"
      }
    }
  ],
  "requirePorts": true,
  "env": {
    "JETTY_BROWSER_SSL_KEYSTORE_PASSWORD": "password",
    "JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD": "password"
  }
}
```

## Credits and acknowledgements

This container is based and modified versions of:

* https://github.com/Unicon/shibboleth-idp-dockerized
* https://github.com/UniconLabs/dockerized-idp-testbed