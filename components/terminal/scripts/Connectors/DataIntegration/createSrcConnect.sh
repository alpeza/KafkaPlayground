composeConector(){

    CONFIG=$(cat <<EOF
{
    "name": "${CONNECTOR_NAME}",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
        "connection.url": "${JDBC_URL}",
        "table.whitelist": "${TABLE_NAME}",
        "mode": "incrementing",
        "incrementing.column.name": "ID",
        "topic.prefix": "my-source-",
        "connection.user": "${DB_USER}",
        "connection.password": "${DB_PASSWORD}",
        "validate.non.null": "false",
        "key.converter": "io.confluent.connect.avro.AvroConverter",
        "key.converter.schema.registry.url": "http://schema-registry:8085",
        "value.converter": "io.confluent.connect.avro.AvroConverter",
        "value.converter.schema.registry.url": "http://schema-registry:8085",
        "key.converter.schemas.enable": "false",
        "value.converter.schemas.enable": "true"
    }
}
EOF
)
    curl -X POST -H "Content-Type: application/json" --data "${CONFIG}" http://connect:8083/connectors
}

CONNECTOR_NAME="my-jdbc-src-connector-$$"
JDBC_URL="jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=oracle)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=XE)))"
TABLE_NAME=MISUSUARIOS
DB_USER=MISTESTS
DB_PASSWORD=mipassword
composeConector