# weekly45
### Learning graphql


---
---
[WIP]


---
---
#### Smart Contract, DApp Decentrilized web, web3 

```js
import { useState } from 'react';
import { ethers } from 'ethers'
import './App.css';
import Greeter from './artifacts/contracts/Greeter.sol/Greeter.json';
const greeterAddress = '0x5....................................';
function App() {
  const [greeting, setGreetingValue] = useState('');
  const requestAccount = async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts'});
  }
  const fetchGreeting = async () => {
    if( typeof window.ethereum !== 'undefined'){
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, provider);
      try{
        const data = await contract.greet();
        console.log('data: ', data);
      }catch(err){
        console.log('Error: ', err);
      }
    }
  }
  const setGreeting = async () => {
    if(!greeting) return;
    if(typeof window.ethereum !== 'undefined'){
      await requestAccount();
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contract = new ethers.Contract(greeterAddress, Greeter.abi, signer);
      const transaction = await contract.setGreeting(greeting);
      setGreetingValue('');
      await transaction.wait();
      fetchGreeting();
    }
  }
  return (
    <div className="App">
      <section className="App-header">
        <button onClick={fetchGreeting}>Fetch Greeting</button>
        <button onClick={setGreeting}>Set Greeting</button>
        <input onChange={e => setGreetingValue(e.target.value)} 
               placeholder='Set greeting' 
               value={greeting}
        />
      </section>
    </div>
  );
}
export default App;
```

- Makefile
```yaml
## dapp
step4550 dapp-ui-init:
	cd dapp && npx create-react-app ui
step4551 dapp-ui-ether:
	cd dapp/ui && npm i ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers
step4552 dapp-ui-ether-create:
	cd dapp/ui && npx hardhat
step4553 dapp-ui-ether-compile:
	cd dapp/ui && npx hardhat compile
step4554 dapp-ui-ether-node-local-network:
	cd dapp/ui && npx hardhat node
step4555 dapp-ui-ether-run:
	cd dapp/ui && npx hardhat run scripts/deploy.js --network localhost
step4556 dapp-ui-ether-start:
	cd dapp/ui && npm run start
```

---
---
### Server - Online Firewall the server Alpine Linux - awall firewall ( iptables, ip6tables )
- Makefile
```yaml
## server online alpine firewall - first steps
step4506 alpine_firewall: 
	apk update && apk upgrade
	apk add ip6tables iptables
	apk add -u awall
	apk version awall
step4507 alpine_kernel_load_module:
	modprobe -v ip_tables
	modprobe -v ip6_tables
	modprobe -v iptable_nat
	rc-update add iptables
	rc-update add ip6tables
  
step4509 alpine_firewall_cloud:
	cat <<EOF > /etc/awall/optional/cloud-server.json 
	{ 
	"description": "Default awall policy to protect Cloud server", 
	"variable": { "internet_if": "eth0" }, 
	"zone": { "internet": { "iface": "$internet_if" } }, 
	"policy": [ 
	{ "in": "internet", "action": "drop" }, 
	{ "action": "reject" } 
	] 
	} 
	EOF 

step4510 alpine_firewall_ssh:
	cat <<EOF > /etc/awall/optional/ssh.json 
	{ 
	"description": "Allow incoming SSH access (TCP/22)",
	"filter": [ 
	{ 
	"in": "internet", 
	"out": "_fw", 
	"service": "ssh", 
	"action": "accept", 
	"conn-limit": { "count": 3, "interval": 60 } 
	} 
	] 
	} 
	EOF 

step4511 alpine_firewall_ping:
	cat <<EOF > /etc/awall/optional/ping.json
	{
		"description": "Allow ping-pong",
		"filter": [
			{
				"in": "internet",
				"service": "ping",
				"action": "accept",
				"flow-limit": { "count": 10, "internal": 6 }
			}
		]
	}
	EOF

step4512 alpine_firewall_out:
	cat <<EOF > /etc/awall/optional/outgoing.json 
	{
		"description": "Allow outgoing connection for dns, http/https, ssh, ping",
		"filter": [
			{
				"in": "_fw",
				"out": "internet",
				"service": ["dns", "http", "https", "ssh", "ping", "ntp"],
				"action": "accept"
			}
		]
	}
	EOF

step4513 alpine_firewall_list:
	awall list
	#cloud-server  disabled  Default awall policy to protect Cloud server
	#outgoing      disabled  Allow outgoing connection for dns, http/https, ssh, ping
	#ping          disabled  Allow ping-pong
	#ssh           disabled  Allow incoming SSH access (TCP/22)


step4514 alpine_firewall_enable:
	awall enable cloud-server
	awall enable ssh
	awall enable ping
	awall enable outgoing

step4515 alpine_firewall_activate:
	awall activate

step4516 alpine_firewall_http:
	cat <<EOF > /etc/awall/optional/http.json
	{
		"description": "Allow incoming http/https (tcp/80 and 443) ports",
		"filter": [
			{
				"in": "internet",
				"out": "_fw",
				"service": [ "http", "https" ],
				"action": "accept"
			}
		]
	}
	EOF
	awall enable http
	awall activate

step4517 alpine_firewall_iptable_list:
	iptables -S
	ip6tables -S

step4518 alpine_firewall_dropped_log:
	dmesg | grep -w DPT=22

step4519 alpine_firewall_disable_reset_awall:
	rc-service iptables stop
	rc-service ip6tables stop
	awall disable cloud-server
	awall disable ssh
	awall disable ping
	awall disable outgoing
	awall disable http
	rc-update del ip6tables
	rc-update del iptables

```

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
