# weekly45
### Learning graphql


---
---
[wip]

---
---
#### Starting the project Neo4j, ui, api
- Running in command line ( terminal )
```yaml
$ make step4500 # cleaning docker images and containers
$ make step4502 # starting docker-compose, local env
```

- Makefile - api graphql
```yaml
step4505 graphql-api-init:
	cd app && npx create-express-typescript-application api -t plain
	cd app && cd api && npm i @neo4j/graphql graphql apollo-server neo4j-driver
```
- Open the browser
  - ui   <http://localhost:4500/>
  - api   <http://localhost:4000/>
  - neo4j   <http://localhost:7474/>

- docker/docker-compose.yaml
```yaml
version: '3.9'
networks:
  app_prv_net:
services:
  ui:
    image: node:alpine
    command: sh -c "npm install && npm run start"
    working_dir: /ui
    container_name: app_ui
    volumes:
      - ../app/ui:/ui
      - ../app/ui/node_modules:/ui/node_modules
    ports:
      - "4500:3000" 
      - "49153:49153"
    environment:
      - NODE_ENV=dev
    networks:
      - app_prv_net
  api:
    image: node:alpine
    command: sh -c "npm install && npm run dev:nodemon"
    working_dir: /api
    container_name: app_api
    volumes:
      - ../app/api:/api
      - ../app/api/node_modules:/api/node_modules
    ports:
      - "4000:4000" 
      - "49155:49153"
    environment:
      - NODE_ENV=dev
    networks:
      - app_prv_net
  neo4j:
    image: neo4j:latest
    container_name: app_neo4j
    ports: 
      - 7474:7474
      - 7687:7687
    environment:
      - NEO4J_AUTH=neo4j/s3cr3t
    networks:
      - app_prv_net   
```

---
---
#### Starting the project Neo4j, ui
- Running in command line ( terminal )
```yaml
$ make step4500 # cleaning docker images and containers
$ make step4502 # starting docker-compose, local env
```

- Open the browser
  - ui   <http://localhost:4500/>
  - neo4j   <http://localhost:7474/>

- Makefile - ui - db neo4j
```yaml
step4500 docker-system-prune:
	docker system prune -af	

step4501 graphql-ui-init:
	cd app && npm uninstall -g create-react-app && npx create-react-app ui --template typescript

step4502 graphql-compose-start:
	docker-compose -f docker/docker-compose.yml up --remove-orphans

```
- docker/docker-compose.yaml
```yaml
version: '3.9'
services:
  ui:
    image: node:16-alpine
    command: sh -c "npm install && npm run start"
    working_dir: /ui
    container_name: app_ui
    volumes:
      - ../app/ui:/ui
      - ../app/ui/node_modules:/ui/node_modules
    ports:
      - "4500:3000" 
      - "49153:49153"
    environment:
      - NODE_ENV=dev
    networks:
      - app_prv_net
  neo4j:
    image: neo4j:latest
    container_name: app_neo4j
    ports: 
      - 7474:7474
      - 7687:7687
    environment:
      - NEO4J_AUTH=neo4j/s3cr3t
networks:
  app_prv_net:
```
- REFERENCE:
  - neo4j
    - <https://neo4j.com/developer/docker/>
    - <https://github.com/neo4j/docker-neo4j>

---
---
#### Starting the project ui base react, typescript, docker-compose local env
---
- Makefile - docker compose
```yaml
step4501 graphql-ui-init:
	cd app && npm uninstall -g create-react-app && npx create-react-app ui --template typescript

step4502 graphql-compose-start:
	docker-compose -f docker/docker-compose.yml up --remove-orphans

step4503 docker-system-prune:
	docker system prune -af	
```

---
- docker/docker-compose.yaml
```yaml
version: '3.9'
services:
  ui:
    image: node:16-alpine
    command: sh -c "npm install && npm run start"
    working_dir: /ui
    container_name: app_ui
    volumes:
      - ../app/ui:/ui
      - ../app/ui/node_modules:/ui/node_modules
    ports:
      - "4500:3000" 
      - "49153:49153"
    environment:
      - NODE_ENV=dev
    networks:
      - app_prv_net
networks:
  app_prv_net:

```
  
---
