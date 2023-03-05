package com.testapi.testapi.controllers;

import com.ibm.mq.MQException;
import com.testapi.testapi.services.MQService;
import org.json.JSONArray;
import org.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("mq")
public class MQController {
    Logger logger = LoggerFactory.getLogger(MQController.class);

    @Autowired
    private MQService mqService;

    @PostMapping("/send/{queueName}")
    public void sendMessage(@RequestBody String message,@PathVariable String queueName) throws MQException, IOException {
        logger.info(String.format("Ha llegado el siguiente MQMessage: %s ", message));
        mqService.sendMessage(queueName,message);
    }

    @GetMapping("/readAll/{queueName}")
    public String readAllMessagesFromQueue(@PathVariable String queueName) throws MQException, IOException, JSONException {
        logger.info(String.format("Se van a leer todos los mensajes de la cola: %s ", queueName));
        String messages = mqService.readAllMessages(queueName).toString();
        JSONArray jsonArray = new JSONArray(messages);
        return jsonArray.toString();
    }
}
