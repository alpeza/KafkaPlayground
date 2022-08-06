echo "Starting ..."
docker-compose up -d
docker stop minikafka_schema-registry_1
docker stop minikafka_test-data_1
docker stop minikafka_connect_1
docker ps | grep minikafka_
docker exec -it minikafka_kafkatool_1 bash