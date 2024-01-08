docker exec -it otus-mysql-docker-otusdb-1 rm /create_base_index.sql
docker cp ./create_base_index.sql otus-mysql-docker-otusdb-1:/create_base_index.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /create_base_index.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql -u sb_crm_user -p12345maxim sb_crm < /create_base_index.sql"
