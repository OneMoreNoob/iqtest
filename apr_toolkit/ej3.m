#!/usr/bin/octave

% data/mini

graphics_toolkit(gnuplot);

% conjunto separable

tr= load('data/mini/trSep.dat');
trlabels = load('data/mini/trSeplabels.dat');
% obtener SVM sin kernel
res = svmtrain(trlabels, tr, '-t 0 -c 1'); %-t: type of SVM (0->linear), -c: cost
% multiplicadores de Lagrange
mult_lagrange = res.sv_coef;
% vectores soporte
vect_soporte = res.SVs;
% vector de pesos
vect_pesos = mult_lagrange'*vect_soporte;
% umbral de la funcion
umbral = -res.rho;
% margen
margen = 1/(vect_pesos*vect_pesos');
% calcular parametros de la frontera lineal
m = vect_pesos(1)/vect_pesos(2) ;
b = umbral/vect_pesos(2);
eq_recta = -m - b;

% representar graficamente
% calcular unos cuantos valores de 'y' y 'x' para dibujar la recta




% conjunto no separable

tr = load('data/mini/tr.dat');
trlabels = load('data/mini/trlabels.dat');
for C = [0.01, 0.1, 1, 10, 100]
   % obtener SVM sin kernel
    res = svmtrain(trlabels, tr, '-t 0 -c 1'); 
    % multiplicadores de Lagrange
    mult_lagrange = res.sv_coef;
    % vectores soporte
    vect_soporte = res.SVs;
    % vector de pesos
    vect_pesos = mult_lagrange'*vect_soporte;
    % umbral de la funcion
    umbral = -res.rho;
    % margen
    margen = 1(vect_pesos*vect_pesos');
    % tolerancia de margen (diapositiva 4.17)
    
    %representar graficamente marcando los vectores erroneos
end