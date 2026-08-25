#!/bin/sh
set -e

mkdir -p /app/data

# تولید Secret اگر تنظیم نشده
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

# ========== ساخت کانفیگ با sed به جای envsubst ==========
cat > /app/config.generated.toml << EOF
port = 443
secret = "$SECRET"
fake_tls_domain = "www.bing.com"

[mtproto]
ad_tag = "https://t.me/YourChannel"
ad_text = "🔥 کانال ما: @YourChannel"

[logging]
level = "info"
EOF

echo "✅ کانفیگ ساخته شد"
cat /app/config.generated.toml

# اجرا
exec /usr/local/bin/fakemtg -config /app/config.generated.toml
