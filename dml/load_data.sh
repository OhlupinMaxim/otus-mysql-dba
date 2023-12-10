docker exec -it otus-mysql-docker-otusdb-1 rm -rf /data_csv
docker cp ./data_csv otus-mysql-docker-otusdb-1:/data_csv
docker cp ./set_localinfile.sql otus-mysql-docker-otusdb-1:/set_localinfile.sql

docker exec -it otus-mysql-docker-otusdb-1 chmod -R 777 /data_csv
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /set_localinfile.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql < /set_localinfile.sql"

docker exec -it otus-mysql-docker-otusdb-1 mysqlimport sb_crm --local --lines-terminated-by="\n" --fields-terminated-by="," --fields-enclosed-by="\"" -c id,username,password,staff_full_name "/data_csv/Staff.csv"
docker exec -it otus-mysql-docker-otusdb-1 mysqlimport sb_crm --local --lines-terminated-by="\n" --fields-terminated-by="," --fields-enclosed-by="\"" -c id,name,article,manufacturer  "/data_csv/Product.csv"
docker exec -it otus-mysql-docker-otusdb-1 mysqlimport sb_crm --local --lines-terminated-by="\n" --fields-terminated-by="," --fields-enclosed-by="\"" -c id,name,address "/data_csv/Shop_Point.csv"
docker exec -it otus-mysql-docker-otusdb-1 mysqlimport sb_crm --local --lines-terminated-by="\n" --fields-terminated-by="," --fields-enclosed-by="\"" -c id,fk_product,fk_shop_point,count_products "/data_csv/Shop_Point_Product.csv"