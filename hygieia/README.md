```bash
mvn clean install package

mvn docker:build

docker-compose up -d

docker exec -ti mongodb \
    mongo localhost/admin \
    --eval 'db.getSiblingDB("dashboard").createUser({user: "db", pwd: "dbpass", roles: [{role: "readWrite", db: "dashboard"}]})'

docker port hygieia-ui # Copy the port

open http://localhost:8088

docker-compose -f test-servers/jenkins/jenkins.yml up -d

open http://localhost:9100
```