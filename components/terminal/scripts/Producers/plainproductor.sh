#!/bin/bash
# Produce mensajes en texto plano hacia un determinado topic
topic="test"


for i in {1..100}
do
  echo "Este es el mensaje número $i"
done | kafka-console-producer.sh --bootstrap-server "kafka:9092" --topic "$topic"