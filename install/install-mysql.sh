git clone https://github.com/aeuge/otus-mysql-docker.git
cp ./init.sql ./otus-mysql-docker
cd ./otus-mysql-docker
docker-compose up -d --wait
sleep 5
docker-compose exec otusdb mysql -u otus_db_user -p12345maxim otus -e "show databases;"