# ============================================
# RunFree Monorepo Makefile
# Unified commands for all apps (JS, Rails, Python)
# ============================================

.PHONY: help install dev stop build test clean

# Default target
help:
	@echo "RunFree Monorepo Commands"
	@echo "========================="
	@echo ""
	@echo "Setup:"
	@echo "  make install     - Install all dependencies"
	@echo "  make setup       - Full setup (install + db)"
	@echo ""
	@echo "Development:"
	@echo "  make dev         - Start all services"
	@echo "  make stop        - Stop all services"
	@echo ""
	@echo "Individual Apps:"
	@echo "  make dev-api     - Start Rails API only"
	@echo "  make dev-ai      - Start Python AI service only"
	@echo "  make dev-web     - Start React web only"
	@echo ""
	@echo "Testing:"
	@echo "  make test        - Run all tests"
	@echo "  make test-api    - Run Rails tests"
	@echo "  make test-ai     - Run Python tests"
	@echo "  make test-js     - Run JS tests"
	@echo ""
	@echo "Database:"
	@echo "  make db-setup    - Create and migrate database"
	@echo "  make db-migrate  - Run migrations"
	@echo "  make db-reset    - Reset database"
	@echo ""
	@echo "Other:"
	@echo "  make build       - Build all apps"
	@echo "  make clean       - Clean all build artifacts"
	@echo "  make lint        - Lint all code"

# ============================================
# Setup
# ============================================

install:
	@echo "Installing JS dependencies..."
	pnpm install
	@echo "Installing Rails dependencies..."
	cd apps/api && bundle install
	@echo "Installing Python dependencies..."
	cd apps/ai-service && pip install -r requirements.txt

setup: install db-setup

# ============================================
# Development
# ============================================

dev:
	docker-compose up

dev-detach:
	docker-compose up -d

stop:
	docker-compose down

dev-api:
	cd apps/api && bundle exec rails server -p 3000

dev-ai:
	cd apps/ai-service && uvicorn app.main:app --reload --port 8000

dev-web:
	pnpm --filter web dev

dev-js:
	pnpm dev

# ============================================
# Testing
# ============================================

test: test-api test-ai test-js

test-api:
	cd apps/api && bundle exec rspec

test-ai:
	cd apps/ai-service && pytest

test-js:
	pnpm test

# ============================================
# Database
# ============================================

db-setup:
	cd apps/api && bundle exec rails db:create db:migrate

db-migrate:
	cd apps/api && bundle exec rails db:migrate

db-reset:
	cd apps/api && bundle exec rails db:reset

db-seed:
	cd apps/api && bundle exec rails db:seed

# ============================================
# Build
# ============================================

build:
	pnpm build

build-api:
	@echo "Rails doesn't need build step"

build-ai:
	@echo "Python doesn't need build step"

# ============================================
# Linting
# ============================================

lint:
	pnpm lint
	cd apps/api && bundle exec rubocop
	cd apps/ai-service && ruff check .

lint-fix:
	pnpm lint --fix
	cd apps/api && bundle exec rubocop -a
	cd apps/ai-service && ruff check . --fix

# ============================================
# Clean
# ============================================

clean:
	pnpm clean
	rm -rf node_modules
	rm -rf apps/api/tmp/*
	rm -rf apps/ai-service/__pycache__
	find . -name "*.pyc" -delete
