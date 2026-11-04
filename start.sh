
#!/bin/bash
set -e

echo "🚀 Starting X-UI + nginx reverse proxy..."

# استفاده از پورتی که Railway تعیین می‌کند
export NGINX_PORT="${PORT:-3000}"

cd /usr/local/x-ui

echo "🔧 Applying panel settings..."
./x-ui setting -port 2053 -webBasePath /managepanel/ || true

echo "🔧 Building nginx.conf for port: $NGINX_PORT"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "▶️ Starting x-ui..."
./x-ui &
X_UI_PID=$!

sleep 3

echo "▶️ Starting nginx on port $NGINX_PORT..."
nginx -t
exec nginx -g "daemon off;"
