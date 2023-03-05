# Kafka Playground

Entorno para trabajar con distintos elementos de [Confluent Kafka](https://www.confluent.io/lp/confluent-kafka/?utm_medium=sem&utm_source=google&utm_campaign=ch.sem_br.brand_tp.prs_tgt.confluent-brand_mt.xct_rgn.emea_lng.eng_dv.all_con.confluent-kafka-general&utm_term=kafka%20confluent&creative=&device=c&placement=&gclid=CjwKCAiAmJGgBhAZEiwA1JZolqiNc7Xtig0Ye3pWk1OJNVhh44hptJ90gPCl0U0lDU_Ml5oXkfLrqRoC2dMQAvD_BwE).

## Instalación

### Requisitos

Disponer de una máquina Linux con docker-compose. Podemos seguir el siguiente [tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
  
### Instalar

* Añadimos al bashrc de `Linux` las siguientes sentencias y realizamos un `source $HOME/.bashrc`:

```bash
export DEVENV_PATH="/path/donde/hacia/este/repo" #TODO
export PATH="$DEVENV_PATH:$PATH"
alias devenv="$DEVENV_PATH/tool/tool.sh"
```

* Para acceder a `Kafka` desde la maquina `host`, por ejemplo si se esta desarrollando algun cliente en Java, es necesario añadir la siguiente sentencias a `/etc/hosts`.

```
127.0.0.1       kafka
127.0.0.1       connect
127.0.0.1       schema-registry
127.0.0.1       mqseries
127.0.0.1       oracle
```

## Comandos

* `devend get`: Ejecuta un `docker ps`
* `devend list`: Ejecuta un list de los componentes de los que disponemos
* `devend deploy <componente>`: Levanta un determinado componente empleando un `docker-compose up -d`
* `devend stop <componente>`: Para un determinado componente empleando el comando `docker-compose stop` 
* `devend logs <componente>`: Muestra los logs del contenedor definido en <core> empleando `docker logs -f <core>`
* `devend exec <componente>`: Accede al contenedor core mediante `docker exec -it`


## Componentes

Los _componentes_ son manifiestos de configuración _docker-compose_ con la configuración de cada contenedor. 

- [core](components/core): Se trata de un Kafka, un Zookeeper y un Akhq
- [connect](components/connect): Se trata de un Confluent Kafka Connect
- [dbvision](components/dbvision): Se trata del gestor de base de datos web [CloudBeaver](https://dbeaver.com/docs/cloudbeaver/)
- [mq](components/mq): Se trata de un servidor de MQSeries
- [oracle](components/oracle): Se trata de un servidor de base de datos Oracle XE
- [schema](components/schema): Se trata de un Confluent Schema Registry
- [terminal](components/terminal): Se trata de un contenedor con las herramientas de Kafka instaladas pensado para ser empleado como terminal
- [testApi](components/testapi): Se trata de un proyecto SpringBoot que permite realizar algunas acciones sobre la plataforma