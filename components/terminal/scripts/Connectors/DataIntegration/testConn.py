import cx_Oracle
# export ORACLE_HOME=/opt/instantclient_19_8
# Configura los detalles de conexión a la base de datos
dsn = cx_Oracle.makedsn(host='localhost', port='1521',
                        service_name='XE')

print(dsn)
user = 'MISTESTS'
password = 'mipassword'

# Establece la conexión a la base de datos
connection = cx_Oracle.connect(user=user, password=password, dsn=dsn)

# Crea un cursor para ejecutar las consultas SQL
cursor = connection.cursor()

# Ejecuta la consulta SQL para seleccionar todos los campos de la vista VW_USUARIOS
query = "SELECT * FROM VW_USUARIOS"
cursor.execute(query)

# Itera a través de los resultados y los imprime en la pantalla
for row in cursor:
    print(row)

# Cierra el cursor y la conexión
cursor.close()
connection.close()
