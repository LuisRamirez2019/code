#!/bin/bash

# Función para contar eventos sísmicos en un área específica para un año y mes dados
count_events() {
    local lat_min=$1
    local lat_max=$2
    local lon_min=$3
    local lon_max=$4
    local year=$5
    local month=$6

    # Utiliza awk para contar el número de eventos sísmicos en el rango de latitud y longitud especificado
    # durante el año y mes dados
    awk -v lat_min="$lat_min" -v lat_max="$lat_max" -v lon_min="$lon_min" -v lon_max="$lon_max" -v year="$year" -v month="$month" '
    $1 == year && $2 == month && $7 >= lat_min && $7 <= lat_max && $8 >= lon_min && $8 <= lon_max {count++}
    END {print count}
    ' SipplCatalog.txt
}

# Lista de puntos de interés con sus coordenadas (latitud y longitud)
points_of_interest=(
    "-21.0 -68.3"
    "-22.0 -69.0"
    "-23.5 -70.2"
)

# Solicita al usuario que ingrese el año y mes de interés
read -p "Enter the year of interest: " year_of_interest
read -p "Enter the month of interest (1-12): " month_of_interest

# Loop para cada punto de interés en la lista
for point in "${points_of_interest[@]}"; do
    latitud=$(echo $point | cut -d' ' -f1)
    longitud=$(echo $point | cut -d' ' -f2)

    # Define las coordenadas del área alrededor del punto de interés
    area_lat_min=$(echo "$latitud - 0.1" | bc)
    area_lat_max=$(echo "$latitud + 0.1" | bc)
    area_lon_min=$(echo "$longitud - 0.1" | bc)
    area_lon_max=$(echo "$longitud + 0.1" | bc)

    # Inicializa el contador de eventos acumulados
    acumulado=0

    # Loop para calcular la cantidad de eventos sísmicos acumulados hasta un cierto año-mes
    for year in $(seq 2007 $year_of_interest); do
        for month in $(seq 1 12); do
            # Detiene el loop si se ha alcanzado el año y mes de interés
            if [ "$year" -eq "$year_of_interest" ] && [ "$month" -gt "$month_of_interest" ]; then
                break
            fi

            # Cuenta eventos dentro del área de interés para el año y mes actuales
            count=$(count_events "$area_lat_min" "$area_lat_max" "$area_lon_min" "$area_lon_max" "$year" "$month")
            count=${count:-0} # Default to 0 if count is empty

            # Actualiza el contador acumulado
            acumulado=$((acumulado + count))

            # Muestra la cantidad de eventos acumulados hasta el año-mes actual
            printf "Up to %d-%02d the number of events in a 0.2x0.2 degrees area around %.1f %.1f is %d\n" "$year" "$month" "$latitud" "$longitud" "$acumulado"
        done
        # Rompe el loop de años si el mes ya se procesó
        if [ "$year" -eq "$year_of_interest" ] && [ "$month" -eq "$month_of_interest" ]; then
            break
        fi
    done
done
