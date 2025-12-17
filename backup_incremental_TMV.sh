#!/bin/bash
# ==========================================================
# Script: backup_incremental_TMV.sh
# Autor: Trishan Mabel Mizhquiri Valencia (TMV)
# Curso: ASIXc - Administració de Sistemes Informàtics en Xarxa
# Fecha: 2025-12-17
# Descripción:
#   Crea una copia de seguridad comprimida del directorio especificado.
#   Cada ejecución genera un archivo único con marca de tiempo.
#   Aplica permisos 644 como preferencia de usuario.
# Requisitos:
#   - Acceso a los directorios de origen y destino.
#   - Espacio suficiente en disco.
#   - Permisos de escritura en /backup (o ruta personalizada).
# Licencia: MIT
# ==========================================================

set -euo pipefail  # Modo estricto

ORIGEN="/home/tmv/datos"
DESTINO_BASE="/backup"
FECHA=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${DESTINO_BASE}/tmv_backup_${FECHA}.tar.gz"

echo "[+] Iniciando copia de seguridad: $(date)"
echo "[+] Origen: $ORIGEN"
echo "[+] Destino: $BACKUP_FILE"

# Verificar que el origen exista
if [ ! -d "$ORIGEN" ]; then
  echo "[!] ERROR: Directorio de origen no encontrado: $ORIGEN"
  exit 1
fi

# Crear directorio de destino si no existe
mkdir -p "$DESTINO_BASE"

# Crear copia de seguridad
if tar -czf "$BACKUP_FILE" -C "$(dirname "$ORIGEN")" "$(basename "$ORIGEN")"; then
  chmod 644 "$BACKUP_FILE"
  echo "[+] Copia de seguridad creada exitosamente."
  ls -lh "$BACKUP_FILE"
else
  echo "[!] ERROR: Falló la creación del archivo de respaldo."
  exit 1
fi

echo "[+] Script finalizado."
