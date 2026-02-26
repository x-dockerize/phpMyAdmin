#!/usr/bin/env bash
set -e

ENV_EXAMPLE=".env.example"
ENV_FILE=".env"

# --------------------------------------------------
# Kontroller
# --------------------------------------------------
if [ ! -f "$ENV_EXAMPLE" ]; then
  echo "❌ $ENV_EXAMPLE bulunamadı."
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  cp "$ENV_EXAMPLE" "$ENV_FILE"
  echo "✅ $ENV_EXAMPLE → $ENV_FILE kopyalandı"
else
  echo "ℹ️  $ENV_FILE mevcut, güncellenecek"
fi

# --------------------------------------------------
# Yardımcı Fonksiyonlar
# --------------------------------------------------
set_env() {
  local key="$1"
  local value="$2"

  if grep -q "^${key}=" "$ENV_FILE"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
  else
    echo "${key}=${value}" >> "$ENV_FILE"
  fi
}

# --------------------------------------------------
# Kullanıcıdan Gerekli Bilgiler
# --------------------------------------------------
read -rp "PHPMYADMIN_SERVER_HOSTNAME (örn: pma.example.com): " PHPMYADMIN_SERVER_HOSTNAME

read -rp "PMA_HOST (boş bırakılırsa: mysql): " INPUT_PMA_HOST
PMA_HOST="${INPUT_PMA_HOST:-mysql}"

read -rp "PMA_USER (boş bırakılırsa: dba): " INPUT_PMA_USER
PMA_USER="${INPUT_PMA_USER:-dba}"

read -rsp "MYSQL_ROOT_PASSWORD: " MYSQL_ROOT_PASSWORD
echo

# --------------------------------------------------
# .env Güncelle
# --------------------------------------------------
set_env PHPMYADMIN_SERVER_HOSTNAME "$PHPMYADMIN_SERVER_HOSTNAME"
set_env PMA_HOST                   "$PMA_HOST"
set_env PMA_USER                   "$PMA_USER"
set_env MYSQL_ROOT_PASSWORD        "$MYSQL_ROOT_PASSWORD"

# --------------------------------------------------
# Sonuçları Göster
# --------------------------------------------------
echo
echo "==============================================="
echo "✅ phpMyAdmin .env başarıyla hazırlandı!"
echo "-----------------------------------------------"
echo "🌐 Hostname      : https://$PHPMYADMIN_SERVER_HOSTNAME"
echo "-----------------------------------------------"
echo "==============================================="
