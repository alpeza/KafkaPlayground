Escribe un programa bash empleando el framework bashly que permita las siguientes opciones:

* `minienv get`: Ejecuta un `docker ps`
* `minienv list`: Ejecuta un list de la carpeta definida en la variable de entorno 'MINIENV_COMPONENTS_PATH'
* `minienv deploy <core>`: Ejecuta un docker-compose up -d 
* `minienv stop <core>`: Para el contenedor definido en `<core>` empleando el comando `docker rm <core> --force` 
* `minienv logs <core>`: Muestra los logs del contenedor definido en <core> empleando `docker logs -f <core>`
* `minienv exec <core>`: Accede al contenedor core mediante `docker exec -it`
