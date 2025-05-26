#!/bin/bash

# Generate self-signed cert if not exists
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
    /tools/generate_cert.sh
fi

# Start NGINX in foreground
exec nginx -g "daemon off;"