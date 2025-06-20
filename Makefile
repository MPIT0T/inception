include srcs/.env

VOL_NAMES := mariadb wordpress

all: up

up: secrets
	@mkdir -p ~/data/wordpress ~/data/mariadb
	docker-compose -f srcs/docker-compose.yml up --build --detach

build:
	docker-compose -f srcs/docker-compose.yml build --no-cache

down:
	docker-compose -f srcs/docker-compose.yml down

start:
	docker-compose -f srcs/docker-compose.yml start

stop:
	docker-compose -f srcs/docker-compose.yml stop

logs:
	docker-compose -f srcs/docker-compose.yml logs --follow

prune:
	docker system prune --all --volumes --force

mysql:
	docker-compose -f srcs/docker-compose.yml exec mariadb mysql

clean:
	docker-compose -f srcs/docker-compose.yml down --volumes --rmi all

fclean: clean
	sudo rm -rf ~/data
	rm -rf ./secrets/

re: fclean up

secrets:
	@mkdir -p $@
	openssl rand -hex -out $@/db_root_password 6
	openssl rand -hex -out $@/db_password 6
	openssl rand -hex -out $@/wp_admin_password 6
	openssl rand -hex -out $@/wp_password 6
	openssl req -x509 -newkey rsa:2048 -keyout $@/ssl_certificate_key -out $@/ssl_certificate -days 365 -nodes -subj "/CN=$(DOMAIN_NAME)" 2> /dev/null

help:
	@echo "Makefile for Docker Compose"
	@echo "Available targets:"
	@echo "  up      - Start services"
	@echo "  build   - Build services"
	@echo "  down    - Remove services"
	@echo "  start   - Start services" 
	@echo "  stop    - Stop services"
	@echo "  logs    - View logs"
	@echo "  prune   - Remove all unused containers and images"
	@echo "  mysql   - Execute mariadb monitor"
	@echo "  re      - Restart services with fclean & up"
	@echo "  fclean  - Call clean and remove data, secrets & certificates"
	@echo "  clean   - Remove volumes and stop services"
	@echo "  help    - Show this help message"

.PHONY: all up build down start stop logs prune mysql re fclean clean secrets