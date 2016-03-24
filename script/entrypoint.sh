#!/usr/bin/env bash

# Enter posix mode for bash
set -o posix
set -e

usage="Usage: entrypoint.sh nimbus|drpc|supervisor|ui|logviewer"

if [ $# -lt 1 ]; then
 echo $usage >&2;
 exit 2;
fi

# Set nimbus address to local ip by default
if [ -z "$CONFIG_NIMBUS_HOST" ]; then
  export CONFIG_NIMBUS_HOST="\"$(hostname -I)\""
fi

# Set zookeeper address to zookeeper by default
if [ -z "$CONFIG_STORM_ZOOKEEPER_SERVERS" ]; then
  export CONFIG_STORM_ZOOKEEPER_SERVERS="[ \"zookeeper\" ]";
fi

function init_storm_yaml() {
    STORM_YAML=$STORM_HOME/conf/storm.yaml
    cp $STORM_HOME/conf/storm.yaml.template $STORM_YAML

    for var in $(compgen -v | grep CONFIG_); do
        name=$var
        confValue=${!var}
        confName=`echo ${name#*CONFIG_} | awk '{print tolower($0)}'`
        confName=`echo $confName | sed -r 's/_/./g'`
        n=`echo $(grep -n "^${confName}:" "${STORM_YAML}" | cut -d : -f 1)`
        if [ ! -z "$n" ]; then
           echo "Override property $confName=$confValue (storm.yaml)"
           sed -i "${n}s|.*|$confName: $confValue|g" $STORM_YAML
        else
           echo "Add property $confName=$confValue (storm.yaml)"
           $(echo "$confName: $confValue" >> ${STORM_YAML})
        fi
    done
}

init_storm_yaml

bin/storm $@

exit 0;
