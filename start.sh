#!/bin/sh
set -e

echo "========== راه‌اندازی پروکسی MTProto =========="

# ایجاد دایرکتوری برای ذخیره Secret
mkdir -p /data

# ========== پیدا کردن باینری ==========
echo "🔍 جستجوی باینری پروکسی..."
find / -name "mtproto-proxy" -o -name "telegram-mtproxy" -o -name "proxy" 2>/dev/null || echo "⚠️ هیچ باینری پیدا نشد"

# تولید Secret اگر خالی باشه
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

# تنظیم TAG
if [ -z "$TAG" ]; then
    echo "⚠️ هشدار: TAG تنظیم نشده"
else
    echo "✅ TAG: $TAG"
fi

# نمایش اطلاعات
echo "=========================================="
echo "🔑 Secret: $SECRET"
echo "📡 Port: $PORT"
echo "🏷️  Tag: $TAG"
echo "=========================================="

# ========== اجرا با مسیر درست ==========
# تلاش با مسیرهای مختلف
if [ -f "/usr/local/bin/mtproto-proxy" ]; then
    echo "✅ اجرا با mtproto-proxy"
    exec /usr/local/bin/mtproto-proxy -p $PORT -s $SECRET -w $WORKERS -t "$TAG"
elif [ -f "/usr/bin/mtproto-proxy" ]; then
    echo "✅ اجرا با /usr/bin/mtproto-proxy"
    exec /usr/bin/mtproto-proxy -p $PORT -s $SECRET -w $WORKERS -t "$TAG"
elif [ -f "/usr/local/bin/telegram-mtproxy" ]; then
    echo "✅ اجرا با telegram-mtproxy"
    exec /usr/local/bin/telegram-mtproxy -p $PORT -s $SECRET -w $WORKERS -t "$TAG"
else
    echo "❌ هیچ باینری پیدا نشد! محتویات /usr/local/bin:"
    ls -la /usr/local/bin/ || echo "دایرکتوری خالی"
    echo "محتویات /usr/bin:"
    ls -la /usr/bin/ | head -20
    exit 1
fi
