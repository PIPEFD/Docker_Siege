# ========================================
#            VARIABLES GENERALES
# ========================================

COMPOSE = docker compose -f docker-compose.yml
GREEN   = \033[0;92m
RED     = \033[0;31m
YELLOW  = \033[0;93m
CYAN    = \033[0;96m
CLEAR   = \033[0m
TIMESTAMP := $(shell date +%Y-%m-%d_%H-%M-%S)
LOG_DIR := logs/logs-$(TIMESTAMP)

# ========================================
#              COMANDOS
# ========================================

all: build up

build:
	@echo "$(CYAN)🔧 Construyendo imágenes...(webserv y siege)$(CLEAR)"
	@$(COMPOSE) build

up:
	@echo "$(GREEN)🚀 Levantando servicios con Docker Compose$(CLEAR)"
	@$(COMPOSE) up --build

down:
	@echo "$(RED)⏹️ Apagando contenedores y limpiando red$(CLEAR)"
	@$(COMPOSE) down --volumes --remove-orphans

rebuild:
	@echo "$(YELLOW)♻️ Reconstruyendo desde cero$(CLEAR)"
	@$(MAKE) down
	@$(MAKE) build
	@$(MAKE) up
valgrind-test:
	@echo "🧪 Ejecutando Webserv con Valgrind y Siege..."
	docker-compose down -v
	docker-compose build
	docker-compose up

logs:
	@$(COMPOSE) logs -f

status:
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

exec-webserv:
	@docker exec -it webserv bash

exec-siege:
	@docker exec -it siege bash

save-logs:
	@echo "$(CYAN)📦 Guardando logs en $(LOG_DIR)$(CLEAR)"
	@mkdir -p $(LOG_DIR)
	@$(COMPOSE) logs > $(LOG_DIR)/full.log
	@for container in $$(docker ps --format '{{.Names}}'); do \
		echo "📁 $$container -> $(LOG_DIR)/$$container.log"; \
		docker logs $$container > $(LOG_DIR)/$$container.log 2>&1; \
	done
	@echo "$(GREEN)✅ Logs guardados correctamente$(CLEAR)"

monitor:
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

network-info:
	@echo "$(CYAN)🌐 Inspeccionando red 'webserv_net'$(CLEAR)"
	@docker network inspect webserv_net || echo "$(RED)❌ Red no encontrada$(CLEAR)"

# ========================================
#              PHONY
# ========================================

.PHONY: all build up down rebuild logs status exec-webserv exec-siege save-logs monitor network-info
