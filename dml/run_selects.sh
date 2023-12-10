docker cp ./select.sql otus-mysql-docker-otusdb-1:/select.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /set_localinfile.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql -u sb_crm_user -p12345maxim sb_crm < /select.sql"
