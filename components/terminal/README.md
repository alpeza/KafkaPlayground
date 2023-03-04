# Terminal

Contenedor pensado para ser empleado a modo de terminal bash y que dispone de las herramientas de Kafka.

## Construir la imagen

```bash
docker build . -t kterminal:latest
```

## Como usar

- 1.- Acceda al contenedor en modo interactivo

```bash
docker exec -it terminal-terminal-1 bash
```

> En la ruta `cd /home` se ha compartido el volumen scripts de esta carpeta por si se quieren hacer
> _scripts_ más complejos.