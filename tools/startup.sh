echo "1.- Creando topics ..."
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic trojo-ejemplo --partitions 1 --replication-factor 1
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic tverde-ejemplo --partitions 1 --replication-factor 1
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic tazul-ejemplo --partitions 1 --replication-factor 1
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic trojo-ejemplo2 --partitions 1 --replication-factor 1
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic tverde-ejemplo2 --partitions 1 --replication-factor 1
kafka-topics.sh --create --bootstrap-server kafka:9092 --topic tazul-ejemplo2 --partitions 1 --replication-factor 1


echo "2.- Creando Acls ..."
kafka-acls.sh --bootstrap-server kafka:9092  --add \
--allow-principal User:urojo1 --operation All --topic "trojo-*" --group 'dir-rojo-*'

kafka-acls.sh --bootstrap-server kafka:9092  --add \
--allow-principal User:uverde1 --operation All --topic "tverde-*" --group 'dir-azul-*'

kafka-acls.sh --bootstrap-server kafka:9092  --add \
--allow-principal User:uazul1 --operation All --topic "tazul-*" --group 'dir-verde-*'

kafka-acls.sh --bootstrap-server kafka:9092  --add \
--allow-principal User:urojo1 --operation Read --topic "tazul-*" --group 'dir-rojo-*'