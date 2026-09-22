#!/bin/sh
set -eu
if [ "$#" -gt 0 ]; then exec "$@"; fi
php artisan schedule:work &
SCHEDULER_PID=$!
php artisan serve --host=0.0.0.0 --port="${PORT:-3000}" &
SERVER_PID=$!
trap 'kill "$SCHEDULER_PID" "$SERVER_PID" 2>/dev/null || true' TERM INT EXIT
wait "$SERVER_PID"
