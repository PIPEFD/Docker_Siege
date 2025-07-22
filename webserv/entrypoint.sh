#!/bin/sh
set -e

VALGRIND_LOG="/tmp/valgrind.log"

echo "[webserv] 🚀 Iniciando Valgrind…"
valgrind \
  --tool=memcheck \
  --leak-check=full \
  --track-origins=yes \
  --show-leak-kinds=all \
  --error-exitcode=42 \
  --log-file="$VALGRIND_LOG" \
  ./webserv default.conf

echo
echo "[webserv] 📋 Resumen de fugas de memoria:"
grep "definitely lost" "$VALGRIND_LOG"
grep "ERROR SUMMARY" "$VALGRIND_LOG"
echo

# Para dejar el contenedor vivo y permita docker logs -f
tail -f /dev/null
