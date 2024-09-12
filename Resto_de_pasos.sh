#!/bin/bash

# Nombre del archivo de salida del mapa
name="mapa1.ps"

# Definición de la región y proyección
r="-72/-67/-29/-18"  # Región de interés (longitud mínima, longitud máxima, latitud mínima, latitud máxima)
j="M12"  # Proyección Mercator
jc="-22.7/-69.3/0.9i"  # Centro y escala para proyección Cassini

# Definición de la región de Chile para el mapa pequeño de referencia
chile="-90/-50/-60/-10"
paleta="wiki-france.cpt"  # Archivo de paleta de colores

# Archivos de grilla y datos
topo_file="topo.grd"  # Archivo de grilla de topografía
events_file="events_grid.grd"  # Archivo de grilla de eventos sísmicos
gradient_file="bi.grd"  # Archivo de gradiente
grid_I_file="int.grd"  # Archivo de grilla de intensidad
volcanes_file="v.txt"  # Archivo de ubicación de volcanes

# Rango de valores para la escala de colores
min_value=-11000
max_value=-5500

# Crear la grilla de topografía recortada a la región de interés
gmt grdcut ETOPO1_Ice_c_gmt4.grd -G${topo_file} -R${r}

# Crear el gradiente para la topografía
gmt grdgradient ${topo_file} -Nt1 -A15 -G${gradient_file}

# Multiplicar el gradiente por 0.25 para ajustar la intensidad
gmt grdmath 0.25 ${gradient_file} MUL = ${grid_I_file}

# Crear el marco del mapa
gmt psbasemap -R${r} -J${j} -Ba5g2f1 -Xc -Yc -K -P > ${name}

# Añadir la imagen de topografía con la paleta de colores
gmt grdimage ${topo_file} -I${grid_I_file} -R${r} -J${j} -C${paleta} -O -K >> ${name}

# Añadir la rosa de los vientos (puntos cardinales)
gmt psbasemap -R${r} -J${j} -TdjTL+w1.5i+l+o0.5i/0.5i -O -K >> ${name}

# Añadir la grilla de eventos sísmicos con la misma paleta de colores
gmt grdimage ${events_file} -R${r} -J${j} -C${paleta} -O -K >> ${name}

# Añadir la línea de costa
gmt pscoast -R${r} -J${j} -Ba5g2f1 -Dh -W0.3,0 -N1 -I4/0.1,39/64/139 -O -K >> ${name}

# Añadir algunos volcanes en el mapa
echo "-69.5 -18.1" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-69.092 -18.42" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-68.83 -19.15" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-67.853 -22.557" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-67.645 -23.236" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}

echo "-67.618 -23.292" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-67.73 -23.37" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-68.83 -19.15" | gmt psxy -R${r} -J${j} -Sc0.2C -W0.5p,0 -Gred  -O -K>> ${name}
echo "-67.7 -23.58" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}
echo "-67.534 -23.743" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}

# Añadir la leyenda de los volcanes en el mapa
echo -71 -20 "Volcanes Chilenos" |  gmt pstext -R${r} -J${j}  -F+f10p,Arial,black+jLM -Gwhite -O -K >> ${name}
echo "-70.5 -20.2" | gmt psxy -R${r} -J${j} -Sc0.5C -W0.5p,0 -Gblue  -O -K>> ${name}

# Crear la escala de colores (paleta)
gmt psscale -C${paleta} -D2i/0.5i/4i/0.2i -R${min_value}/${max_value}/0/1 -JX4i/0.2i -Ba500f250 -By+l"Unidades" -O -K >> ${name}

# Añadir un mapa pequeño de referencia para la región de Chile
gmt pscoast -R${chile} -JC${jc} -Bg6 -Dh -X+0.2i -Y-2i -A12 -W0.25p -G255/187/86 -O >> ${name}

# Convertir el archivo PS a PNG
gmt psconvert ${name} -A -Tg -V

# Convertir el archivo PS a PDF
gmt psconvert ${name} -A -Tf -P 
