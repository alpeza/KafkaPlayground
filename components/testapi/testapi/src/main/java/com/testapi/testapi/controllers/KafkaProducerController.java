package com.testapi.testapi.controllers;

import com.testapi.testapi.services.PlainProducer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("kafka")
public class KafkaProducerController {
    Logger logger = LoggerFactory.getLogger(KafkaProducerController.class);

    private PlainProducer kafkaProducer;

    public KafkaProducerController(PlainProducer kafkaProducer) {
        this.kafkaProducer = kafkaProducer;
    }

    @PostMapping("/sendplain/{topic}")
    public ResponseEntity<String> postPlainMessage(@RequestBody String message, @PathVariable String topic){
        kafkaProducer.sendMessage(topic,message);
        return ResponseEntity.ok("Message sent to kafka topic");
    }
}
