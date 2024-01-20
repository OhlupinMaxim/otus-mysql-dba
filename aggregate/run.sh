docker cp ./group.sql otus-mysql-docker-otusdb-1:/group.sql

docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /group.sql

docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql classicmodels < /group.sql"