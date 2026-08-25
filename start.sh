#!/bin/sh
set -e

echo "========== شروع دیباگ =========="
echo "مسیر جاری: $(pwd)"
echo "محتوای /usr/local/bin:"
ls -la /usr/local/bin/ || echo "❌ دایرکتوری وجود نداره"

echo "========== جستجوی mtg =========="
which mtg || echo "❌ mtg در PATH نیست"
find / -name "mtg" 2>/dev/null || echo "❌ فایل mtg پیدا نشد"

echo "========== ادامه فرآیند =========="
mkdir -p /app/data

if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

cat > /app/config.generated.toml << EOF
port = 443
secret = "$SECRET"
fake_tls_domain = "www.bing.com"

[mtproto]
ad_tag = "https://t.me/DungeonMonarch"
ad_text = "Ch"

[logging]
level = "info"
EOF

echo "✅ کانفیگ ساخته شد"

# ========== بررسی نهایی قبل از اجرا ==========
if [ -f "/usr/local/bin/mtg" ]; then
    echo "✅ فایل mtg وجود داره"
    file /usr/local/bin/mtg
    chmod +x /usr/local/bin/mtg
    echo "اجرای دستور:"
    exec /usr/local/bin/mtg -config /app/config.generated.toml
else
    echo "❌ فایل mtg وجود نداره!"
    exit 1
fi
