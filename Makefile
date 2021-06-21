include .env
#user=..
#servers=..
## Makefile variables
# servers-if-not-set-then-default?=localhost ## if servers not set, then set with value localhost
servers-exec-cmd!=hostname  ## execute command and set stdout to variable server
servers-exec-usr-id!=id  ## execute command and set stdout to variable server

.PHONY: view-hostname
step00 view-hostname:
	@echo $(servers-exec-cmd)
	@echo '$(servers-exec-usr-id)'

step4501 graphql-ui-init:
	cd app && npm uninstall -g create-react-app && npx create-react-app ui --template typescript

step4502 graphql-compose-start:
	docker-compose -f docker/docker-compose.yml up --remove-orphans

step4503 docker-system-prune:
	docker system prune -af	


#step4403 docker-psql-ls:
#	docker exec docker_db_1 psql -Upostgres -d postgres -c '\l'	
#
#step4403-t docker-psql-ls-twitter:
#	docker exec docker_db_1 psql -Upostgres -d twitter-clone -c '\l'	

#step4404 docker-psql-exec-sql:
#	docker exec docker_db_1 psql -Upostgres -d postgres --file=/sql/input.sql > docker/sql/output.sql

#step4405 docker-pg_dump:
#	docker exec docker_db_1 pg_dump -Upostgres -d twitter_clone > docker/sql/create_tables.sql

#step4406 api-prisma-generate:
#	cd twitter-clone/api && npx prisma generate
#
#step4407 api-prisma-migrate-dev:
#	cd twitter-clone/api && npx prisma migrate dev --name init
#
#step4408 api-prisma-migrate-up:
#	cd twitter-clone/api && npx prisma migrate resolve --applied 20210615195142_init
#
#step4409 api-prisma-introspect: 
#	cd twitter-clone/api && npx prisma introspect ## check prisma - db
#
#step4410 api-npm-prisma-update: 
#	cd twitter-clone/api && npm i -D prisma && npm i @prisma/client 

#step4411 docker-psql-drop-database:
#	docker exec docker_db_1 psql -Upostgres -d postgres -c "DROP DATABASE twitter_clone;"	


#step01 app: ## Nestjs - GraphQL
#	mkdir app	
#step02 api-create: app
#	cd app && nest new api
#step03 api-install:
#	cd app/api && npm install @nestjs/graphql graphql-tools graphql apollo-server-express class-validator uuid
#step04 generate-types:
#	cd app/api && ./node_modules/.bin/ts-node src/scripts/generate.ts
#step05 api-test:
#	curl -X POST http://localhost:4000/graphql -H "Content-Type: application/json" -d '{ "query":"query { article(  id: 1 ){ id, title, content } }"}'

#ssh-manual-root-update: ## debian - dev-user:staff /usr/loca/bin
#	apt -y update; apt -y upgrade;
#	adduser dev-user; 
# usermod -g ssh dev-user; 
#	usermod -g staff dev-user;
# chown root:staff /usr/local/bin; chmod 775 /usr/local/bin;
# hostname [dev.domain];

step10 ssh-docker-install: ## debian - docker install
	$(foreach server, $(servers),  ssh root@$(server)	" apt -y install apt-transport-https software-properties-common ca-certificates curl gnupg lsb-release; echo  'deb [arch=amd64] https://download.docker.com/linux/debian  buster stable' | tee /etc/apt/sources.list.d/docker.list > /dev/null ;  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" ; apt -y update; apt -y remove docker docker-engine docker.io containerd runc; apt -y install docker-ce docker-ce-cli containerd.io; usermod -aG docker $(user) " \ ;)

step20 ssh-login:
	$(foreach server, $(servers),  ssh-copy-id  $(user)@$(server);)
	
step21 ssh-ls:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ls -a";)

step22 ssh-docker-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "docker run hello-world";)


#step23 ssh-k3d-install:
#	$(foreach server, $(servers),  ssh root@$(server) "curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash";)
	
#step24 ssh-k3d-test:
#	$(foreach server, $(servers),  ssh $(user)@$(server) "k3d --help;";)

#kubectl-version!=curl -L -s https://dl.k8s.io/release/stable.txt
#step25 ssh-kubectl-install:
#	$(foreach server, $(servers),  ssh root@$(server) "curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg; curl -LO 'https://dl.k8s.io/release/$(kubectl-version)/bin/linux/amd64/kubectl'; install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl;";)

#step26 ssh-kubectl-test:
#	$(foreach server, $(servers),  ssh $(user)@$(server) "kubectl version";)

#step30 ui-create:
#	mkdir ui; cd ui; npm init -y; mkdir public; mkdir src; touch public/index.html; \
#	npm i -D typescript webpack webpack-cli http-server react react-dom @types/react @types/react-dom; \
#	npx tsc --init ;\
#	echo 'UI - Created - React Typescript';

## SSH Multi Server commands execute 
step100 ssh-arkade:
	$(foreach server, $(servers),  ssh $(user)@$(server) "curl -sLS https://dl.get-arkade.dev | sh";)

step101 ssh-ark-kubectl:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ark get kubectl; mv ./.arkade/bin/kubectl /usr/local/bin/;";)

step102 ssh-kubectl-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "kubectl version";)

step103 ssh-ark-k3d:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ark get k3d; mv ./.arkade/bin/k3d /usr/local/bin/;";)

step104 ssh-k3d-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "k3d version";)

## Default usage k3d - kubernetes cluster fast, simple, minimal
k3d-cluster-create:
	k3d cluster create
kubectl-cluster-info:
	kubectl cluster-info
k3d-cluster-delete:
	k3d cluster delete

## Kubernetes - interaction - cleaning
step150 kubectl-get-nodes:
	kubectl get nodes
step151 kubectl-get-sc:
	kubectl get sc
step152 kubectl-top-nodes:
	kubectl top nodes
step153 kubectl-kube-system-top-nodes:
	kubectl -n kube-system top nodes
step154 kubectl-get-componentstatus:
	kubectl get componentstatus

step170 kubectl-run-busybox:
	kubectl run -it --rm shell1 --image busybox

step171 docker-haproxy-sh:
	docker run -it haproxy:alpine /bin/sh
	
step180 kubectl-watch-get-pods:
	watch kubectl get pods -o wide

step190 kubectl-delete-all:
	kubectl delete all --all # delete all resources in all namespaces
