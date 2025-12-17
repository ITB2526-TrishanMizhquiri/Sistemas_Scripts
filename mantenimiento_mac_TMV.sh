#!/bin/bash
# ==========================================================
# Script: mantenimiento_mac_TMV.sh
# Autor: Trishan Mabel Mizhquiri Valencia (TMV)
# Curso: ASIXc - Administració de Sistemes Informàtics en Xarxa
# Fecha: 2025-12-17
# Descripción:
#   Realiza tareas de mantenimiento en macOS:
#   - Limpieza de cachés de usuario.
#   - Rotación y limpieza de logs del sistema.
#   - Verificación básica de espacio en disco.
# Requisitos:
#   - Ejecución con privilegios de administrador (sudo).
#   - macOS 10.15 o superior.
# Nota: No elimina datos personales, solo cachés temporales.
# Licencia: MIT
# ==========================================================

echo "[+] Iniciando mantenimiento del sistema macOS..."
echo "[+] Fecha: $(date)"

# Verificar que se ejecute con sudo
if [ "$EUID" -ne 0 ]; then
  echo "[!] Este script requiere privilegios de administrador (sudo)."
  exit 1
fi

echo "[+] Limpiando cachés de usuario..."
rm -rf ~/Library/Caches/* 2>/dev/null
echo "[+] Cachés limpias."

echo "[+] Limpiando logs antiguos del sistema..."
rm -f /private/var/log/asl/*.asl 2>/dev/null
log erase --all 2>/dev/null
echo "[+] Logs gestionados."

echo "[+] Verificando espacio en disco..."
df -h / | tail -n +2

echo "[+] Mantenimiento completado."
echo "[+] Recomendación: Reiniciar el sistema si se observan mejoras de rendimiento."
