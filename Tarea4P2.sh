#!/bin/bash
 
# Pedir al usuario que ingrese la latitud y longitud del punto de interés
echo "Por favor, ingresa la latitud y longitud del punto de interés (separados por un espacio):"
read latitud longitud
 
# Definir las coordenadas del área alrededor del punto de interés
area_lat_min=$(bc <<< "$latitud - 0.1")
area_lat_max=$(bc <<< "$latitud + 0.1")
area_lon_min=$(bc <<< "$longitud - 0.1")
area_lon_max=$(bc <<< "$longitud + 0.1")
 
# Inicializar el contador de eventos acumulados
 
acumulado=0
 
# Loop para calcular la cantidad de eventos sísmicos acumulados hasta un cierto año-mes
for year in {2007..2014}; do
    for month in {1..12}; do
        # Contar eventos dentro del área de interés
        count=$(awk -v lat_min="$area_lat_min" -v lat_max="$area_lat_max" -v lon_min="$area_lon_min" -v lon_max="$area_lon_max" -v year="$year" -v month="$month" '$7 >= lat_min && $7 <= lat_max && $8 >= lon_min && $8 <= lon_max && $1 == year && $2 == month {count++} END {print count}' SipplCatalog.txt)
       
        # Actualizar el contador acumulado
        acumulado=$((acumulado + count))
       
        # Mostrar la cantidad de eventos acumulados hasta el año-mes actual
        printf "Up to %d-%02d the number of events in a .2x.2 degrees area around %s %s is %d\n" "$year" "$month" "$latitud" "$longitud" "$acumulado"
    done
done
