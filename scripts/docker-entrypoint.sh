#!/bin/sh
#
# Change ownership of homedir to user passed in with PUID and PGID, then assume that identity for execution
set -eu

if [ "$(id -u)" = '0' ]; then
  chown "${PUID}:${PGID}" "${HOME}" && \
    exec su-exec "${PUID}:${PGID}" \
       env HOME="$HOME" "$@"
else
  exec "$@"
fi