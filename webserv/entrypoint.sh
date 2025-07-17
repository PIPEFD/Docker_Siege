#!/bin/bash

echo "🧠 Lanzando Webserv con Valgrind..."
mkdir -p /logs
# valgrind --track-origins=yes --leak-check=full ./webserv default.conf 2> /logs/valgrind.log
timeout 60s valgrind --track-origins=yes --leak-check=full ./webserv default.conf > /logs/valgrind.log 2>&1

echo "⏳ Esperando a que el servidor esté disponible en http://localhost:8081 ..."
while ! curl -s http://localhost:8081 > /dev/null; do
    sleep 1
done
echo "✅ Servidor activo, comenzando test con Siege"

wait $PID