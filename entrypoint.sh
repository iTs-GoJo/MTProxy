#!/bin/sh
set -e

# تولید Secret خودکار اگر تنظیم نشده
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret : $SECRET"
    export SECRET
fi

# جایگزینی متغیرها در config.toml
envsubst < /app/config.toml > /app/config.generated.toml

# اجرای fakemtg با کانفیگ
exec /usr/local/bin/fakemtg -config /app/config.generated.toml
