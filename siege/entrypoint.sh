#!/bin/sh
set -e

URL="http://webserv:8081"
USERS=1000
DURATION="2M"
SIEGE_LOG="/root/.siege/siege.log"

echo "[siege] 🔄 Prueba NORMAL…"
siege -c$USERS -t$DURATION "$URL"

echo
echo "[siege] 🛑 Pausa 10s antes del BENCHMARK…"
sleep 10

echo "[siege] ⚡ Prueba BENCHMARK…"
siege -b -c$USERS -t$DURATION "$URL"

echo
echo "[siege] 📊 Resultados del log de Siege:"
if [ -f "$SIEGE_LOG" ]; then
  cat "$SIEGE_LOG" | awk '
    /Transactions:/  { print "→ " $0 }
    /Throughput:/    { print "→ " $0 }
    /Response time/  { print "→ " $0 }
  '
else
  echo "¡No encuentro $SIEGE_LOG!"
fi
echo

echo "[siege] 🖥️ Uso de memoria en el contenedor (MB):"
free -m

echo "[siege] ✅ Pruebas completadas."
# Para dejar el contenedor vivo y revisar dentro
tail -f /dev/null
