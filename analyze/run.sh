docker cp ./analyze.sql otus-mysql-docker-otusdb-1:/analyze.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /analyze.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql -u client -p12345maxim classicmodels < /analyze.sql"
