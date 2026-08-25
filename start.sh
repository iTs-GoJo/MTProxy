#!/bin/sh
set -e

echo "========== راه‌اندازی پروکسی MTProto =========="

# ایجاد دایرکتوری برای ذخیره Secret
mkdir -p /data

# تولید Secret اگر خالی باشه
if [ -z "$SECRET" ]; then
    SECRET=$(openssl rand -hex 16)
    echo "✅ Secret جدید تولید شد: $SECRET"
    export SECRET
fi

# تنظیم TAG (آدرس کانال)
if [ -z "$TAG" ]; then
    echo "⚠️  هشدار: TAG تنظیم نشده، کانال نمایش داده نمیشه"
else
    echo "✅ TAG: $TAG"
fi

# نمایش اطلاعات نهایی
echo "=========================================="
echo "🔑 Secret: $SECRET"
echo "📡 Port: $PORT"
echo "🏷️  Tag: $TAG"
echo "=========================================="

# اجرای پروکسی رسمی تلگرام
exec /usr/local/bin/telegram-mtproxy -p $PORT -s $SECRET -w $WORKERS -t "$TAG"
