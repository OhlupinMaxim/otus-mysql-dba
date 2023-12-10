docker cp ./move.sql otus-mysql-docker-otusdb-1:/move.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /move.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql sb_crm < /move.sql"
