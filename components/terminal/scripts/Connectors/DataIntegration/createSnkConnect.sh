composeConector(){

    CONFIG=$(cat <<EOF
{
    "name": "${CONNECTOR_NAME}",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "connection.url": "${JDBC_URL}",
        "connection.user": "${DB_USER}",
        "connection.password": "${DB_PASSWORD}",
        "table.name.format": "${TABLE_NAME}",
        "topics": "${TOPIC}",
        "auto.create": false,
        "auto.evolve": false,
        "insert.mode": "insert",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "value.converter.schema.registry.url": "http://schema-registry:8085"
    }
}
EOF
)
    curl -X POST -H "Content-Type: application/json" --data "${CONFIG}" http://connect:8083/connectors
}

CONNECTOR_NAME="my-jdbc-snk-connector-$$"
JDBC_URL="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=oracle)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=XE)))"
TABLE_NAME=MISUSUARIOS_DESTINO
TOPIC=my-source-MISUSUARIOS
DB_USER=MISTESTS
DB_PASSWORD=mipassword
composeConector