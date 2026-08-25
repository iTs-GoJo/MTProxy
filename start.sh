#!/bin/sh
set -e

echo "========== راه‌اندازی پروکسی MTProto =========="

# ایجاد دایرکتوری
mkdir -p /app/data

# تولید Secret
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

# تنظیمات
PORT=${PORT:-443}
WORKERS=${WORKERS:-4}
TAG=${TAG:-""}

echo "=========================================="
echo "🔑 Secret: $SECRET"
echo "📡 Port: $PORT"
echo "👷 Workers: $WORKERS"
echo "🏷️  Tag: $TAG"
echo "=========================================="

# اجرا
exec /usr/local/bin/mtproto-proxy \
    --port $PORT \
    --secret $SECRET \
    --workers $WORKERS \
    --tag "$TAG" \
    --nat-info "0.0.0.0:$PORT"
