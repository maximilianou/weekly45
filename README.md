# weekly45
Learning graphql


#### Starting the project ui base react, typescript, docker-compose local env
---
- Makefile
```sh
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
```
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
---
