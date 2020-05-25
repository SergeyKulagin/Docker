#!/bin/bash -e

# extraction pod index, primary goal for kubernetes Stateful pods
if [[ -n "$HOSTNAME" ]]; then
  export HOST_INDEX="$((${HOSTNAME##*-}))"
fi

# Store original IFS config, so we can restore it at various stages
ORIG_IFS=$IFS

if [[ -z "$KAFKA_ZOOKEEPER_CONNECT" ]]; then
  echo "ERROR: missing mandatory config: KAFKA_ZOOKEEPER_CONNECT"
  exit 1
fi

if [[ -z "$KAFKA_PORT" ]]; then
  export KAFKA_PORT=9092
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
  if [[ -n "$BROKER_ID_COMMAND" ]]; then
    KAFKA_BROKER_ID=$(eval "$BROKER_ID_COMMAND")
    export KAFKA_BROKER_ID
  else
    # By default auto allocate broker ID
    export KAFKA_BROKER_ID=-1
  fi
fi

if [[ -z "$KAFKA_LOG_DIRS" ]]; then
  export KAFKA_LOG_DIRS="$KAFKA_HOME/data-logs"
fi

if [[ -n "$KAFKA_HEAP_OPTS" ]]; then
  sed -r -i 's/(export KAFKA_HEAP_OPTS)="(.*)"/\1="'"$KAFKA_HEAP_OPTS"'"/g' "$KAFKA_HOME/bin/kafka-server-start.sh"
  unset KAFKA_HEAP_OPTS
fi

KAFKA_ADVERTISED_LISTENERS=`eval echo $KAFKA_ADVERTISED_LISTENERS`
KAFKA_LISTENERS=`eval echo $KAFKA_LISTENERS`

#Issue newline to config file in case there is not one already
echo "" >>"$KAFKA_HOME/config/server.properties"

(
  function updateConfig() {
    key=$1
    value=$2
    file=$3

    # Omit $value here, in case there is sensitive information
    echo "[Configuring] '$key' in '$file'"

    # If config exists in file, replace it. Otherwise, append to file.
    if grep -E -q "^#?$key=" "$file"; then
      sed -r -i "s@^#?$key=.*@$key=$value@g" "$file" #note that no config values may contain an '@' char
    else
      echo "$key=$value" >>"$file"
    fi
  }

  # Fixes #312
  # KAFKA_VERSION + KAFKA_HOME + grep -rohe KAFKA[A-Z0-0_]* /opt/kafka/bin | sort | uniq | tr '\n' '|'
  EXCLUSIONS="|KAFKA_VERSION|KAFKA_HOME|KAFKA_DEBUG|KAFKA_GC_LOG_OPTS|KAFKA_HEAP_OPTS|KAFKA_JMX_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_LOG|KAFKA_OPTS|"

  # Read in env as a new-line separated array. This handles the case of env variables have spaces and/or carriage returns. See #313
  IFS=$'\n'
  for VAR in $(env); do
    env_var=$(echo "$VAR" | cut -d= -f1)
    if [[ "$EXCLUSIONS" == *"|$env_var|"* ]]; then
      echo "Excluding $env_var from broker config"
      continue
    fi

    if [[ $env_var =~ ^KAFKA_ ]]; then
      kafka_name=$(echo "$env_var" | cut -d_ -f2- | tr '[:upper:]' '[:lower:]' | tr _ .)
      updateConfig "$kafka_name" "${!env_var}" "$KAFKA_HOME/config/server.properties"
    fi

    if [[ $env_var =~ ^LOG4J_ ]]; then
      log4j_name=$(echo "$env_var" | tr '[:upper:]' '[:lower:]' | tr _ .)
      updateConfig "$log4j_name" "${!env_var}" "$KAFKA_HOME/config/log4j.properties"
    fi
  done
)

if [[ -n "$CUSTOM_INIT_SCRIPT" ]]; then
  eval "$CUSTOM_INIT_SCRIPT"
fi

if [[ -n "$JAAS_CONFIG" ]]; then
  echo $"$JAAS_CONFIG" >"$KAFKA_HOME/kafka_server_jaas.conf"
  export KAFKA_OPTS=-Djava.security.auth.login.config=$KAFKA_HOME/kafka_server_jaas.conf
fi

exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"
