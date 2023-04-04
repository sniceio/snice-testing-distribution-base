#!/bin/bash

export SNICE_DOCKER=true
export SNICE_DEFAULT_GATEWAY=`route -n | egrep "^0.0.0.0" | awk '{print $2}'`
export SNICE_PRIMARY_INTERFACE=`route -n | egrep "^0.0.0.0" | awk '{print $8}'`
# export SNICE_PRIMARY_HOST_IP=`ifconfig $SNICE_PRIMARY_INTERFACE | grep inet | awk '{print $2}'`
export SNICE_SERVICE_ID=`sha1sum <<<"$SNICE_PRIMARY_HOST_IP"|tr a-z A-Z|cut -c1-32`


CLASSPATH=$(JARS=(lib/*.jar); IFS=:; echo "${JARS[*]}")

if [ -d "lib_user" ] 
then
CLASSPATH=$CLASSPATH:$(JARS=(lib_user/*.jar); IFS=:; echo "${JARS[*]}")
fi

exec java -Djava.net.preferIPv4Stack=true -Dlogback.configurationFile=file:logback.xml -cp "$CLASSPATH" io.snice.testing.runtime.Snice "$@"
