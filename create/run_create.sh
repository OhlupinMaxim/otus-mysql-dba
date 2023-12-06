docker cp ./create_db.sql otus-mysql-docker-otusdb-1:/create_db.sql
docker cp ./create_struct.sql otus-mysql-docker-otusdb-1:/create_struct.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /create_db.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /create_struct.sql

docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql < /create_db.sql"
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql -u sb_crm_user -p12345maxim sb_crm < /create_struct.sql"