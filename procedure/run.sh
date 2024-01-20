docker cp ./procedures.sql otus-mysql-docker-otusdb-1:/procedures.sql
docker exec -it otus-mysql-docker-otusdb-1 chmod 777 /procedures.sql
docker exec -it otus-mysql-docker-otusdb-1 bash -c "mysql < /procedures.sql"

# # run as client
docker exec -it otus-mysql-docker-otusdb-1 mysql -u client -p12345maxim classicmodels -e "CALL classicmodels.products_by_filters(1, 'Vintage Cars', NULL, NULL, 10, 10)"
# not access for manager
docker exec -it otus-mysql-docker-otusdb-1 mysql -u manager -p12345maxim classicmodels -e "CALL classicmodels.products_by_filters(1, 'Vintage Cars', NULL, NULL, 10, 10)"

# # run as manager
docker exec -it otus-mysql-docker-otusdb-1 mysql -u manager -p12345maxim classicmodels -e "CALL classicmodels.get_orders('19 YEAR', 'customerName')"
# # not access for client
docker exec -it otus-mysql-docker-otusdb-1 mysql -u client -p12345maxim classicmodels -e "CALL classicmodels.get_orders('19 YEAR', 'customerName')"



