docker cp ./sample.sql otus-mysql-docker-otusdb-1:/sample.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /sample.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql < /sample.sql"

