#!/bin/bash

envtpl /etc/webdis.json.tpl

/etc/init.d/redis-server start
exec /usr/local/bin/webdis /etc/webdis.json
