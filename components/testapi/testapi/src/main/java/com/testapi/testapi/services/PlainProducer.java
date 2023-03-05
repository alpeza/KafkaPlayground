package com.testapi.testapi.services;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

/**
 * Productor de texto plano
 */
@Service
public class PlainProducer {

    private static final Logger logger = LoggerFactory.getLogger(PlainProducer.class);

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    public void sendMessage(String topic, String message){
        logger.info(String.format("Escribiendo en el topic: %s -> %s",topic, message));
        kafkaTemplate.send(topic, message);
    }
}