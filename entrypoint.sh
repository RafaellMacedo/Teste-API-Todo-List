#!/bin/bash
set -e

# remove pid antigo
rm -f /app/tmp/pids/server.pid

exec "$@"
