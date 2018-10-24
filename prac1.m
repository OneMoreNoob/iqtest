#!/usr/bin/octave

graphics_toolkit(gnuplot);
%inventado

tr= load('data/mini/trSep.dat');
trlabels = load('data/mini/trSeplabels.dat');

% obtener SVM sin kernel
res = svmtrain(trlabels, tr, '-t 0 -c 1'); %-t: type of SVM (0->linear), -c: cost


% multiplicadores de Lagrange
ml = res.sv_coef;


% vectores soporte
vs = res.SVs;


% vector de pesos
w = ml'*vs;


% umbral de la funcion
w0 = -res.rho;


% margen
margen = 1/(w*w');

% calcular parametros de la frontera lineal

m = w(1)/w(2) ;
b = w0/w(2);
recta = -m - b;
% representar graficamente






% no separable

tr = load('data/mini/tr.dat');
trlabels = load('data/mini/trlabels.dat');
% obtener SVM sin kernel
trres = svmtrain(trlabels, tr, '-t 0 -c 1'); %poner valor grande de c
% multiplicadores de Lagrange
mltr = trres.sv_coef;
% vectores soporte
vstr = trres.SVs;
% vector de pesos
wtr = mltr'*vstr;
% umbral de la funcion
w0tr = -trres.rho;
% margen

margen = 1(w*w');
