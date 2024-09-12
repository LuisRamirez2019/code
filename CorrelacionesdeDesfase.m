%% cargamos los datos
N=readmatrix('iN_ice_extent.dat.txt');
%comparamos mes de febrero(3ra columna) con el mes de mayo
figure
plot(N(:,1),N(:,3),N(:,1),N(:,6))
%
%% le sacamos la pendiente
figure
plot(N(:,1),detrend(N(:,3)),N(:,1),detrend(N(:,6)))
%
%% calculamos la correlacion.
%
rho_AB=corrcoef(detrend(N(:,3)),detrend(N(:,6)))
rho_AB(2,1) %0.3400 --)elevamos al cuadrado--) 0.1156 --) 11.56% de varianza compartida
%rho_ABB=corr(detrend(N(:,3)),detrend(N(:,6))) %0.3400 dio lo mismo que
%corrcoef(2,1) o (1,2)
%
%% calculamos la significancia estadistica.
[rho_AB, P_AB]=corr(detrend(N(:,3)),detrend(N(:,6)))
P_AB %0,0276, esto seria el rechazo 
100-P_AB*100 %97.2406, supera el 95%... estamos super bien, esto es lo 
%aceptado o acertado que seria nuestro experimento
%
%% B: correlacion con desfase y significancai estadistica
% utilizamos xcorr
[vcor,desfase]=xcorr(detrend(N(:,6)),detrend(N(:,3)),'coeff');
%el coef al final, como opcion permite la correlacion con desfase sea
%normalizada
%
%
%% hacemos figura
figure
plot(desfase, vcor)
%hay una primera correlacion, QUE ES LA QUE SIEMPRE SE MIRA PRIMERO
% A UN DESFASE DE 0, PERO HAY OTRA FUERTE CORRELACION,pero la mas fuerte es la segunda.
%
%creen una matriz
CRD=[desfase' vcor];
%
% que es lo que dice la teoria?
%[vcorr,desfase]=xcorr(B,A,'coef')
%si corr ) 0 y desfase(corr) ) 0 entonces A esta en avance a B
%si corr ) 0 y desfase(corr) ) 0 entonces A esta en retardo a B
%sera vrdd?
%
%
%
%que le dice este plot?
%
%hay que correr una de las series de 11 años 
%
%
%% 
% original, sin desfase 
subplot(3,1,1)
plot(N(:,1),detrend(N(:,3)),N(:,1),detrend(N(:,6)))
%la primera serie en retardo con respecto a la segunda 
subplot(3,1,2)
plot(N(12:end,1),detrend(N(1:31,3)),N(:,1),detrend(N(:,6)))
%
%La segunda serie en retardo con respecto a la primera
subplot(3,1,3)
plot(N(:,1),detrend(N(:,3)),N(12:end,1),detrend(N(1:31,6)))


%autocorrelacion dice como se parece tu serie a ella misma.
