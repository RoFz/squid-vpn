#!/bin/bash
set -e

pidfile="/var/run/squid/squid.pid"

if [ -f "$pidfile" ]; then
  echo "squid.pid file exists. Removing it..."
  rm -f "$pidfile"
fi

if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /config/squid.conf -z
  fi
  if [[ ! -d /var/lib/squid/ssl_db/ ]]; then
    echo "Initializing certificates DB (ssl_db)..."
    /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db/ -M 40MB
  fi
  echo "Starting squid..."
  exec $(which squid) -f /config/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
