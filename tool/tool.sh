source $DEVENV_PATH/tool/config.sh
# Función para mostrar el mensaje de ayuda
show_help() {
  echo "Uso: minienv <command> [<args>]"
  echo ""
  echo "Comandos:"
  echo "  get               Ejecuta un docker ps"
  echo "  list              Ejecuta un list de la carpeta definida en la variable de entorno 'MINIENV_COMPONENTS_PATH'"
  echo "  deploy <core>     Ejecuta un docker-compose up -d"
  echo "  stop <core>       Para el contenedor definido en <core> empleando el comando 'docker rm <core> --force'"
  echo "  logs <core>       Muestra los logs del contenedor definido en <core> empleando 'docker logs -f <core>'"
  echo "  exec <core>       Accede al contenedor core mediante 'docker exec -it'"
  echo ""
  echo "Opciones:"
  echo "  -h, --help        Muestra esta ayuda y sale"
}

# Comprueba si se proporcionó un comando
if [[ $# -eq 0 ]]; then
  echo "Se requiere un comando"
  echo ""
  show_help
  exit 1
fi

# Procesa las opciones de línea de comandos
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

# Ejecuta el comando correspondiente
case "$1" in
  get)
    docker ps
    ;;
  list)
    ls -l "$MINIENV_COMPONENTS_PATH" | awk '{ print "-  "$9 }'
    ;;
  deploy)
    if [[ $# -lt 2 ]]; then
      echo "Se requiere el nombre del core"
      exit 1
    fi
    docker-compose -f "$MINIENV_COMPONENTS_PATH/$2/docker-compose.yml" up -d
    ;;
  stop)
    if [[ $# -lt 2 ]]; then
      echo "Se requiere el nombre del core"
      exit 1
    fi
    docker-compose -f "$MINIENV_COMPONENTS_PATH/$2/docker-compose.yml" stop
    ;;
  logs)
    if [[ $# -lt 2 ]]; then
      echo "Se requiere el nombre del core"
      exit 1
    fi
    docker logs -f "$2"
    ;;
  exec)
    if [[ $# -lt 2 ]]; then
      echo "Se requiere el nombre del core"
      exit 1
    fi
    docker exec -it "$2" bash
    ;;
  *)
    echo "Comando no reconocido: $1"
    echo ""
    show_help
    exit 1
    ;;
esac

exit 0
