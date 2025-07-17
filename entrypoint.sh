#!/bin/bash

# Lanza el servidor
./webserv default.conf &

# Espera a que el servidor esté disponible
echo "Esperando a que el servidor esté disponible en http://localhost:8081 ..."
until curl -s http://localhost:8081/get > /dev/null; do
  sleep 0.5
done

echo "✅ Servidor activo, comenzando test con Siege"
siege -b http://localhost:8081/index.html
# siege -f /root/.siege/siege.conf -C http://localhost:8081

