


region=$(gmt grdinfo puntotriple_highresolution.grd -I0.001)


angulo=0


gmt makecpt -CGMT:ocean.cpt -T-4400/0/100 -Z -N > nueva_paleta.cpt
gmt makecpt -Czambezi-proximity.cpt -T0/400 >> nueva_paleta.cpt

while [ $angulo -le 360 ]
do 
    gmt begin $angulo png 
	gmt grdgradient puntotriple_highresolution.grd -A$angulo -Gilumination.grd
	gmt grdimage puntotriple_highresolution.grd -Iilumination.grd $region -JM15c -Bafg -Cnueva_paleta.cpt
	gmt pscoast -JM15c -Bafg -Df -Ia -W0.5p,blue $region
	gmt colorbar -Cnueva_paleta.cpt -Bafg $region -JM15c -Bxafg -By+1"Altura (m)"
    gmt end show
    angulo=$((angulo+30))
done	
