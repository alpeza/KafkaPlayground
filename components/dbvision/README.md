# DBVision

Herramienta pensada para la gestión de bases de datos.

## Usuario y password
El usuario y password del navegador es:

```
usuario: adminroot
password: adminroot
```

## Datasources

### Oracle

```json
"oracle_thin-186abe99d2e-60182b84ce42fbb4": {
			"provider": "oracle",
			"driver": "oracle_thin",
			"name": "OracleLocal",
			"save-password": true,
			"configuration": {
				"host": "oracle",
				"port": "1521",
				"database": "XE",
				"url": "jdbc:oracle:thin:@oracle:1521:XE",
				"configurationType": "MANUAL",
				"type": "dev",
				"properties": {
					"oracle.jdbc.timezoneAsRegion": "false"
				},
				"provider-properties": {
					"@dbeaver-sid-service@": "SID",
					"oracle.logon-as": "Normal"
				},
				"auth-model": "oracle_native"
			}
		}
```