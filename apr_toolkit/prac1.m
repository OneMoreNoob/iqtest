#!/usr/bin/octave

%graphics_toolkit(gnuplot);
%inventado

trSep = load('data/mini/trSep.dat');
trSeplabels = load('data/mini/trSeplabels.dat');
tr = load('data/mini/tr.dat');
trlabels = load('data/mini/trlabels.dat');

% obtener SVM sin kernel
trSepres = svmtrain(trSeplabels, trSep, '-t 0 -c 1'); %-t: type of SVM (0->linear), -c: cost
trres = svmtrain(trlabels, tr, '-t 0 -c 1'); %poner valor grande de c

% multiplicadores de Lagrange
mlSep = trSepres.sv_coef;
mltr = trres.sv_coef;

% vectores soporte
vsSep = trSepres.SVs;
vstr = trres.SVs;

% vector de pesos

% umbral de la funcion

% margen

% calcular parametros de la frontera lineal

% representar graficamente
