acls_output_matrix_file="matrix.csv"
topics_output_list_file="topics.txt"

# Función que se conecta a Kafka y retorna una matriz en formato csv con las acls.
extractACLsMatrix(){
    list_output_file="out.txt"
    rm -f "$acls_output_matrix_file"
    # Sacamos un fichero el listado de todas las acls
    kafka-acls.sh --list --bootstrap-server kafka:9092 > $list_output_file
    # Parseamos el fichero de acls linea a linea
    regexResource=".*resourceType=(\w+), name=(.*), patternType=(\w+)"
    regexUser=".*User:u(\w+)1,.*operation=(\w+)"
    while IFS= read -r line
    do
        # LINEA TIPO 1: Procesamos la línea: 
        # Current ACLs for resource `ResourcePattern(resourceType=TOPIC, name=testTopic, patternType=LITERAL)`: 
        if [[ "$line" =~ $regexResource ]]; then
            resourceType="${BASH_REMATCH[1]}"
            name="${BASH_REMATCH[2]}"
            patternType="${BASH_REMATCH[3]}"
            resourceRegister="$resourceType,$name,$patternType"
        fi
        # LINEA TIPO 2: Procesamos la línea: 
        # (principal=User:urojo1, host=*, operation=READ, permissionType=ALLOW)
        if [[ "$line" =~ $regexUser ]]; then
            app="${BASH_REMATCH[1]}"
            permissionType="${BASH_REMATCH[2]}"
            appRegister="$app,$permissionType,$resourceRegister" 
            echo "$appRegister" >> "$acls_output_matrix_file"
        fi
    done < "$list_output_file"
}

# Extract topics
extractTopics(){
    kafka-topics.sh --bootstrap-server kafka:9092 --list > "$topics_output_list_file"
}

# Muestra los topics sobre los que una aplicacion se le ha asignado algún tipo de permiso
selectAppAllowedTopicsFromAclMatix(){
    app="$1"
    cat "$acls_output_matrix_file" | grep "$app," | grep "TOPIC" | awk -F ',' '{ print $4 }' | sort | uniq | sed "s/\*//"
}

# Muestra el nombre de los topics sobre los que una aplicación tiene permisos
getAllowedTopicsForApp(){
    app="$1"
    acls_output_list_file="aclslist.txt"
    selectAppAllowedTopicsFromAclMatix "$app" > "$acls_output_list_file"
    grep -Ff "$acls_output_list_file" "$topics_output_list_file" 
}


paramApp=$1
#1.- Extraemos las ACLs actules en un fichero csv
extractACLsMatrix
#2.- Extraemos los topics actuales en un txt
extractTopics
#3.- Hacemos un join entre los topics actuales desplegados y las acls 
#    de una determinada aplicacion
getAllowedTopicsForApp "$paramApp"
# Borramos ficheros temporales
rm -f "$list_output_file" "$acls_output_matrix_file" "$topics_output_list_file" "$acls_output_list_file"