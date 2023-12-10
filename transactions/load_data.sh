docker exec -it otus-mysql-docker-otusdb-1 rm -rf /load_data_local
docker exec -it otus-mysql-docker-otusdb-1 rm -rf /load_data.sql
docker cp ./data otus-mysql-docker-otusdb-1:/load_data_local
docker cp ./load_data.sql otus-mysql-docker-otusdb-1:/load_data.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod -R 777 /load_data_local
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /load_data.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql sb_crm --local-infile < /load_data.sql"
