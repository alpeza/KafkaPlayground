package com.testapi.testapi.services;

import com.ibm.mq.*;
import com.ibm.mq.constants.MQConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public class MQService {
    private static final Logger logger = LoggerFactory.getLogger(MQService.class);
    @Autowired
    private MQQueueManager mqQueueManager;

    /**
     * Envía un mensaje plano en formato a una determinada cola MQ
     * @param queueName
     * @param message
     * @throws MQException
     * @throws IOException
     */
    public void sendMessage(String queueName, String message) throws MQException, IOException {
        int openOptions = MQC.MQOO_INPUT_AS_Q_DEF | MQC.MQOO_OUTPUT;
        MQQueue queue = mqQueueManager.accessQueue(queueName, openOptions);
        MQMessage mqMessage = new MQMessage();
        mqMessage.format = MQC.MQFMT_STRING;
        mqMessage.writeString(message);
        MQPutMessageOptions mqPutMessageOptions = new MQPutMessageOptions();
        queue.put(mqMessage, mqPutMessageOptions);
        queue.close();
    }

    public List<String> readAllMessages(String queueName) throws MQException, IOException {
        int openOptions = MQC.MQOO_INPUT_AS_Q_DEF | MQC.MQOO_FAIL_IF_QUIESCING;
        MQQueue queue = mqQueueManager.accessQueue(queueName, openOptions);
        List<String> messages = new ArrayList<>();
        int msgc=0;
        while (true) {
            logger.info("Tratando de leer mensaje " + Integer.toString(msgc));
            MQMessage mqMessage = new MQMessage();
            MQGetMessageOptions gmo = new MQGetMessageOptions();
            gmo.options |= MQC.MQGMO_WAIT;
            gmo.waitInterval = 5000;
            try {
                queue.get(mqMessage, gmo);
                messages.add(mqMessage.readString(mqMessage.getMessageLength()));
            } catch (MQException e) {
                if (e.reasonCode == MQConstants.MQRC_NO_MSG_AVAILABLE) {
                    break;
                } else {
                    throw e;
                }
            }
            msgc++;
        }
        queue.close();
        return messages;
    }

}
