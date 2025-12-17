#!/bin/bash
# ==========================================================
# Script: integridad_sistema_TMV.sh
# Autor: Trishan Mabel Mizhquiri Valencia (TMV)
# Curso: ASIXc - Administració de Sistemes Informàtics en Xarxa
# Fecha: 2025-12-17
# Descripción:
#   Verifica la integridad de archivos críticos del sistema
#   mediante hashes SHA256. Si es la primera ejecución,
#   genera una base de hashes. En ejecuciones posteriores,
#   compara y alerta si hay modificaciones.
# Aplicación: Seguridad, detección de intrusos (HIDS básico).
# Requisitos:
#   - Acceso a archivos sensibles (ejecutar como root o con sudo).
#   - Directorio /var/log accesible.
# Licencia: MIT
# ==========================================================

set -euo pipefail

ARCHIVOS_CRITICOS=(
  "/etc/passwd"
  "/etc/shadow"
  "/etc/group"
  "/etc/ssh/sshd_config"
  "/etc/crontab"
)
HASH_FILE="/var/log/hashes_sistema_TMV.log"

echo "[+] Verificación de integridad de archivos críticos"
echo "[+] Fecha: $(date)"

# Crear base de hashes si no existe
if [ ! -f "$HASH_FILE" ]; then
  echo "[+] Primera ejecución: generando base de hashes..."
  touch "$HASH_FILE"
  chmod 600 "$HASH_FILE"  # solo root
  for archivo in "${ARCHIVOS_CRITICOS[@]}"; do
    if [ -f "$archivo" ]; then
      sha256sum "$archivo" >> "$HASH_FILE"
      echo "  [+] Registrado: $archivo"
    fi
  done
  echo "[+] Base de hashes creada en $HASH_FILE"
  exit 0
fi

# Verificar integridad
echo "[+] Comparando hashes actuales con la base..."
CAMBIOS=$(sha256sum -c "$HASH_FILE" 2>/dev/null | grep -v "OK$" || true)

if [ -z "$CAMBIOS" ]; then
  echo "[+] Todos los archivos están intactos. ¡Ningún cambio detectado!"
else
  echo "[!] ALERTA: Se detectaron modificaciones en los siguientes archivos:"
  echo "$CAMBIOS"
  # Opcional: enviar alerta por correo, journalctl, etc.
fi

echo "[+] Verificación finalizada."
