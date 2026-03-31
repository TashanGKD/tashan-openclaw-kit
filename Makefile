SHELL := /bin/bash

.PHONY: prepare up down logs dashboard health check check-repo sync-local refresh-local

prepare:
	./scripts/prepare-state.sh

up: prepare
	docker compose up -d openclaw-gateway

down:
	docker compose down

logs:
	docker compose logs -f openclaw-gateway

dashboard: prepare
	docker compose run --rm openclaw-cli dashboard --no-open

health: prepare
	docker compose run --rm openclaw-cli health

check:
	./scripts/check.sh

check-repo:
	./scripts/check.sh --repo-only

sync-local:
	./scripts/bootstrap-local.sh

refresh-local:
	./scripts/bootstrap-local.sh --force
