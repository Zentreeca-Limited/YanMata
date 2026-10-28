#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# YanMata Deployment Pipeline Script
# Target: 52.0.227.75 (yanmata.zentreeca.org)
# ==============================================================================

SERVER_HOST="${SERVER_HOST:-52.0.227.75}"
SERVER_USER="${SERVER_USER:-ubuntu}"
KEY_PATH="${1:-${SERVER_SSH_KEY_PATH:-$HOME/Downloads/yanmata.pem}}"
DEPLOY_DIR="/var/www/yanmata"

echo "=========================================="
echo "🚀 YanMata Production Deployment Pipeline"
echo "Target: ${SERVER_USER}@${SERVER_HOST}:${DEPLOY_DIR}"
echo "Key:    ${KEY_PATH}"
echo "=========================================="

if [ ! -f "${KEY_PATH}" ]; then
  echo "❌ Error: SSH key not found at ${KEY_PATH}"
  echo "Usage: $0 [path/to/yanmata.pem]"
  exit 1
fi

chmod 400 "${KEY_PATH}" 2>/dev/null || true

# 1. Run local builds & tests
echo "📦 Step 1: Building production web and admin applications..."
npm run build

echo "🧪 Step 2: Running backend test suite..."
(cd apps/api && php artisan test)

# 2. Rsync Backend
echo "📤 Step 3: Deploying backend code..."
rsync -avz --delete \
  --exclude '.git' \
  --exclude 'node_modules' \
  --exclude 'vendor' \
  --exclude '.env' \
  --exclude 'tests' \
  --exclude 'storage' \
  --exclude 'bootstrap/cache/*.php' \
  --exclude 'database/database.sqlite' \
  -e "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no" \
  apps/api/ "${SERVER_USER}@${SERVER_HOST}:${DEPLOY_DIR}/backend/"

# 3. Rsync Web SPA
echo "📤 Step 4: Deploying public web SPA..."
rsync -avz --delete \
  -e "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no" \
  apps/web/dist/ "${SERVER_USER}@${SERVER_HOST}:${DEPLOY_DIR}/web/"

# 4. Rsync Admin SPA
echo "📤 Step 5: Deploying editorial admin SPA..."
rsync -avz --delete \
  -e "ssh -i ${KEY_PATH} -o StrictHostKeyChecking=no" \
  apps/admin/dist/ "${SERVER_USER}@${SERVER_HOST}:${DEPLOY_DIR}/admin/"

# 5. Remote Post-Deploy Provisioning
echo "⚙️  Step 6: Executing post-deploy tasks on remote server..."
ssh -i "${KEY_PATH}" -o StrictHostKeyChecking=no "${SERVER_USER}@${SERVER_HOST}" "bash -s" << 'EOF'
set -euo pipefail
cd /var/www/yanmata/backend

echo "  -> Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction --quiet

echo "  -> Running database migrations..."
php artisan migrate --force

echo "  -> Optimizing framework caches..."
php artisan optimize

echo "  -> Securing directory permissions..."
sudo chown -R ubuntu:www-data /var/www/yanmata
sudo chmod -R 775 /var/www/yanmata
sudo chmod -R g+s /var/www/yanmata
sudo chmod 664 /var/www/yanmata/backend/database/database.sqlite

echo "  -> Reloading PHP-FPM..."
sudo systemctl reload php8.3-fpm

echo "  -> Reloading Caddy..."
sudo systemctl reload caddy
EOF

# 6. Verification Smoke Test
echo "🔍 Step 7: Performing health-check smoke test..."
STATUS_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yanmata.zentreeca.org" "http://${SERVER_HOST}/up" || echo "FAIL")
STATUS_API=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yanmata.zentreeca.org" "http://${SERVER_HOST}/api/v1/content" || echo "FAIL")
STATUS_WEB=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yanmata.zentreeca.org" "http://${SERVER_HOST}/" || echo "FAIL")
STATUS_ADMIN=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: yanmata.zentreeca.org" "http://${SERVER_HOST}/admin" || echo "FAIL")

echo "  -> Health endpoint (/up): ${STATUS_HEALTH}"
echo "  -> API catalog (/api/v1/content): ${STATUS_API}"
echo "  -> Public web (/): ${STATUS_WEB}"
echo "  -> Editorial admin (/admin): ${STATUS_ADMIN}"

if [ "${STATUS_HEALTH}" = "200" ] && [ "${STATUS_API}" = "200" ] && [ "${STATUS_WEB}" = "200" ]; then
  echo "=========================================="
  echo "✅ YanMata deployed successfully and verified live!"
  echo "🌐 Live at: https://yanmata.zentreeca.org"
  echo "=========================================="
else
  echo "⚠️ Deployment completed with warning: one or more health checks did not return HTTP 200."
  exit 1
fi
