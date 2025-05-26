.PHONY: up down build clean fclean re

all: build up

up:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env up -d

down:
	docker compose -f srcs/docker-compose.yml down

build:
	docker compose -f srcs/docker-compose.yml --env-file srcs/.env build

clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker system prune -a --volumes -f

re: fclean build up
