FROM osixia/openldap:1.1.6
MAINTAINER Mesosphere support@mesosphere.io

ADD rfc2307bis/rfc2307bis.ldif /etc/ldap/schema/
ADD rfc2307bis/rfc2307bis.schema /etc/ldap/schema/
ADD rfc2307bis/rfc2307bis.conf /container/service/slapd/schema/rfc2307bis.conf
ADD rfc2307bis/startup.sh /container/service/slapd/startup.sh
