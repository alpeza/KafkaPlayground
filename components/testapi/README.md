# API Rest de propósito general.


## Endpoints

### Kafka

| Endpoint        |Method  | Definición |
|-----------------|--------|------------|
|`/kafka/sendplain/<topic>`| `POST` | Inserta un mensaje en el topic especificado |


### MQ

| Endpoint            |Method  | Definición |
|---------------------|--------|------------|
|`/mq/send/<cola>`    | `POST` | Inserta un mensaje en la cola especificada |
|`/mq/readAll/<cola>` | `GET`  | Lee todos los mensajes de la cola MQ especificada |