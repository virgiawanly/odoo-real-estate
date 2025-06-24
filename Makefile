WEB_DB_NAME = odoo_postgres
DOCKER = docker
DOCKER_COMPOSE = ${DOCKER}-compose
CONTAINER_ODOO = odoo
CONTAINER_DB = odoo-postgres

.PHONY: help start stop restart console psql logs odoo db addon

help:
	@echo "Available targets:"
	@echo "  start								Start Odoo and PostgreSQL containers"
	@echo "  stop									Stop Odoo and PostgreSQL containers"
	@echo "  restart							Restart Odoo and PostgreSQL containers"
	@echo "  console							Open Odoo container console"
	@echo "  psql									Open PostgreSQL container console"
	@echo "  logs odoo						Show Odoo container logs"
	@echo "  logs db							Show PostgreSQL container logs"
	@echo "  addon <addon_name>	Restart and update addon"

start:
	${DOCKER_COMPOSE} up -d

stop:
	${DOCKER_COMPOSE} down

restart:
	${DOCKER_COMPOSE} restart

console:
	${DOCKER_COMPOSE} exec -it ${CONTAINER_ODOO} odoo shell --db_host=${CONTAINER_DB} -d ${WEB_DB_NAME} -r ${CONTAINER_ODOO} -w ${CONTAINER_ODOO}

psql:
	${DOCKER} exec -it ${CONTAINER_DB} psql -U ${CONTAINER_ODOO} -d ${WEB_DB_NAME}

define log_target
	@if [ "${1}" = "odoo" ]; then \
		${DOCKER_COMPOSE} logs -f ${CONTAINER_ODOO}; \
	elif [ "${1}" = "db" ]; then \
		${DOCKER_COMPOSE} logs -f ${CONTAINER_DB}; \
	else \
		echo "Invalid logs target. Use 'make logs odoo' or 'make logs db'."; \
	fi
endef

logs:
	$(call log_target,$(word 2,$(MAKECMDGOALS)))

define upgrade_addon
	${DOCKER} exec -it ${CONTAINER_ODOO} odoo --db_host=${CONTAINER_DB} -d ${WEB_DB_NAME} -r ${CONTAINER_ODOO} -w ${CONTAINER_ODOO} -u ${1}
endef

addon: restart
	$(call upgrade_addon,$(word 2,$(MAKECMDGOALS)))
