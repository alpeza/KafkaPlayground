# Docker-compose tool

## Instalación

### Requisitos

Disponer de una máquina Linux con docker-compose. Podemos seguir el siguiente [tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04)
  
### Instalar

Añadimos al bashrc de `Linux` las siguientes sentencias y realizamos un `source $HOME/.bashrc`:

```bash
export DEVENV_PATH="/path/donde/hacia/este/repo" #TODO
export PATH="$DEVENV_PATH:$PATH"
alias devenv="$DEVENV_PATH/tool/tool.sh"
```


## Comandos

* `devend get`: Ejecuta un `docker ps`
* `devend list`: Ejecuta un list de los componentes de los que disponemos
* `devend deploy <componente>`: Levanta un determinado componente empleando un `docker-compose up -d`
* `devend stop <componente>`: Para un determinado componente empleando el comando `docker-compose stop` 
* `devend logs <componente>`: Muestra los logs del contenedor definido en <core> empleando `docker logs -f <core>`
* `devend exec <componente>`: Accede al contenedor core mediante `docker exec -it`

