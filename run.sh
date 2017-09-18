#!/bin/bash

set -e

if [ "${1:0:1}" != '-' ]; then
  exec "$@"
fi

exec java -jar lib/sonar-application-$SONAR_VERSION.jar \
  -Dsonar.log.console=true \
  -Dsonar.security.realm="LDAP" \
  -Dldap.url="ldap://devops-ldap:389" \
  -Dldap.bindDn="cn=admin,dc=ibm,dc=com" \
  -Dldap.bindPassword="zaq12wsx" \
  -Dldap.user.baseDn="dc=ibm,dc=com" \
  -Dldap.user.realNameAttribute="cn" \
  -Dldap.user.emailAttribute="mail" \
  -Dldap.user.request="(&(objectClass=inetOrgPerson)(uid={login}))" \
  -Dsonar.jdbc.username="$SONARQUBE_JDBC_USERNAME" \
  -Dsonar.jdbc.password="$SONARQUBE_JDBC_PASSWORD" \
  -Dsonar.jdbc.url="$SONARQUBE_JDBC_URL" \
  -Dsonar.web.javaAdditionalOpts="$SONARQUBE_WEB_JVM_OPTS -Djava.security.egd=file:/dev/./urandom" \
  "$@"
