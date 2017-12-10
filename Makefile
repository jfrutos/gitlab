all:

#docker-compose files
GITLAB_COMPOSE_FILE := gitlab/docker-compose.yml
REGISTRY_COMPOSE_FILE := registry/docker-compose.yml

help:
	${INFO} ""
	${INFO} "-- Help Menu"
	${INFO} ""
	${INFO} "   1. make clean-docker-environment   - clean your docker enviroment. \
	Delete containers, images, volumes, networks "
	${INFO} "   2. make create-gitlab-docker-machine - Create a VM machine to gitlab environment"
	${INFO} "   3. make create-registry-docker-machine - Create a VM machine to gitlab environment"
	${INFO} "   4. make gitlab-build - Build gitlab dockers environment"
	${INFO} "   5. make gitlab-clean - Clean gitlab dockers environment"
	${INFO} "   6. make gitlab-start - Start gitlab environment"
	${INFO} "   7. make gitlab-stop - Stop gitlab environment"
	${INFO} "   8. make gitlab-restat - Restart gitlab environment"
	${INFO} "   9. make gitlab-runner-restart - Restart runner docker"
	${INFO} "   10. make registry-build - Build registry dockers environment"
	${INFO} "   11. make registry-clean - Clean registry dockers environment"

gitlab-runner-start:
		${INFO} "Building runner"
		@docker-compose -f $(GITLAB_COMPOSE_FILE) build runner
		${INFO} "Starting runner"
		@docker-compose -f $(GITLAB_COMPOSE_FILE) up -d runner
		${INFO} "Runner environment Started."

gitlab-runner-stop:
		${INFO} "Stoping runner"
		@docker-compose -f $(GITLAB_COMPOSE_FILE) stop runner
		${INFO} "Cleaning runner"
		@docker-compose -f $(GITLAB_COMPOSE_FILE) rm -f runner
		${INFO} "Gitlab runner stopped"

gitlab-runner-restart: gitlab-runner-stop gitlab-runner-start

gitlab-clean:
	${INFO} "Cleaning gitlab dockers"
	@docker-compose -f $(GITLAB_COMPOSE_FILE) down -v

gitlab-build:
	${INFO} "Building gitlab environment ....."
	@docker-compose -f $(GITLAB_COMPOSE_FILE) build
	${INFO} "Gitlab environment builded"

gitlab-start:
	${INFO} "Starting gitlab environment"
	@docker-compose -f $(GITLAB_COMPOSE_FILE) up -d
	${INFO} "Gitlab environment Starting.... Type 'make gitlab-logs' for the logs"

gitlab-stop:
		${INFO} "Stoping gitlab environment"
		@docker-compose -f $(GITLAB_COMPOSE_FILE) stop
		${INFO} "Gitlab environment stopped"

gitlab-restart: gitlab-stop gitlab-start

gitlab-logs:
	@docker-compose -f $(GITLAB_COMPOSE_FILE) logs -f


create-gitlab-docker-machine:
	${INFO} "Creating gitlab VM ..."
	@docker-machine create --driver virtualbox  --virtualbox-memory 2048 gitlab
	@docker-machine env gitlab
	@eval "$(shell docker-machine env gitlab)"
	${INFO} "VM create and docker runtime linked ...."

create-registry-docker-machine:
	${INFO} "Creating registry VM ..."
	@docker-machine create --driver virtualbox  --virtualbox-memory 2048 registry
	@docker-machine env registry
	@eval "$(shell docker-machine env registry)"
	${INFO} "VM create and docker runtime linked ...."

registry-clean:
	${INFO} "Cleaning registry dockers"
	@docker-compose -f $(REGISTRY_COMPOSE_FILE) down -v

registry-build:
	${INFO} "Building registry environment ....."
	@docker-compose -f $(REGISTRY_COMPOSE_FILE) build
	${INFO} "Registry environment builded"

registry-start:
	${INFO} "Starting registry environment"
	@docker-compose -f $(REGISTRY_COMPOSE_FILE) up -d
	${INFO} "registry environment Starting.... Type 'make registry-logs' for the logs"

registry-stop:
		${INFO} "Stoping registry environment"
		@docker-compose -f $(REGISTRY_COMPOSE_FILE) stop
		${INFO} "registry environment stopped"

registry-restart: registry-stop registry-start

registry-logs:
	@docker-compose -f $(REGISTRY_COMPOSE_FILE) logs -f

stop-all-containers:
	${INFO} "Stopping containers ..."
	@docker stop $(shell docker ps -a -q) 2>/dev/null || true

remove-all-containers:
	${INFO} "Removing containers ..."
	@docker rm -f $(shell docker ps -a -q) 2>/dev/null || true

remove-all-images:
	${INFO} "Removing images ..."
	@docker rmi -f $(shell docker images  -q) 2>/dev/null || true

remove-all-volumes:
	${INFO} "Removing volumes ..."
	@docker volume rm  $(shell docker volume ls  -q) 2>/dev/null || true

remove-all-networks:
	${INFO} "Removing networks ..."
	@docker network rm  $(shell docker network ls  -q) 2>/dev/null || true

clean-docker-environment: stop-all-containers remove-all-containers \
	remove-all-images remove-all-volumes remove-all-networks
	${INFO} "Dockers environment clean"

#Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
	printf $(YELLOW); \
	echo "=> $$1"; \
	printf $(NC)' SOME_VALUE
