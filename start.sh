#!/bin/sh
set -e

mkdir -p /app/data

# تولید Secret
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

# ساخت کانفیگ
cat > /app/config.generated.toml << EOF
port = 443
secret = "$SECRET"
fake_tls_domain = "www.bing.com"

[mtproto]
ad_tag = "https://t.me/dungeonmonarch"
ad_text = "ch"

[logging]
level = "info"
EOF

echo "✅ کانفیگ ساخته شد"
cat /app/config.generated.toml

# ========== اجرا با اسم درست ==========
exec /usr/local/bin/mtg -config /app/config.generated.toml
