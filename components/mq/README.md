
# Deploy

1.- La primera vez que se arranque es necesario acceder al contenedor vía terminal `docker exec -it <contenedor mq>` y ejecutar las
siguientes sentencias.

```
runmqsc QM1
ALTER QMGR CHLAUTH (DISABLED)
EXIT
```

2.- Una vez hecho esto podremos acceder al [dashboard https://localhost:9443/](https://localhost:9443/). 

> Nótese que es __https__ `https://localhost:9443/`

Accederemos con las siguientes credenciales:
- Usuario: `admin`
- Password: `passw0rd`

