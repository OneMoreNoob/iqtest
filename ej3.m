#!/usr/bin/octave

% data/mini

graphics_toolkit("gnuplot");

% conjunto separable

load('data/mini/trSep.dat');
load('data/mini/trSeplabels.dat');
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
b1 = - (umbral - 1) / vect_pesos(2);
b2 = - (umbral + 1) / vect_pesos(2);

% representar graficamente
% calcular unos cuantos valores de 'y' y 'x' para dibujar la recta

X  = [1:0.001:7];
Y  = m * X + b ;
Y1 = m * X + b1;
Y2 = m * X + b2;

plot(X, Y, X, Y1, X, Y2,
	tr(trlabels==1, 1), tr(trlabels==1, 2), 'x',
    tr(trlabels==2, 1), tr(trlabels==2, 2), 's',
    tr(res.sv_indices, 1), tr(res.sv_indices, 2), '+');
pause;


% conjunto no separable

load('data/mini/tr.dat');
load('data/mini/trlabels.dat');
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
    margen = 1/(vect_pesos*vect_pesos');
    % tolerancia de margen (diapositiva 4.17)
    tolerancia_margen_sv = (abs(lagrange) == C) .* (1 - sign(lagrange) .* (vect_soporte * vect_pesos' + umbral));
	tolerancia_margen = zeros(size(trlabels));
	tolerancia_margen(res.sv_indices) = tolerancia_margen_sv;
	multiplicadores_lagrange = zeros(size(trlabels));
	multiplicadores_lagrange(res.sv_indices) = res.sv_coef;

    %representar graficamente marcando los vectores erroneos
	# se marcan los vectores soporte y los que tienen error o error de margen
	t = 0:1:7;
	plot(tr1(:,1),tr1(:,2),"sr","markersize",7,"markerfacecolor",[0.7,0.3,0.3],
		tr2(:,1),tr2(:,2),"ob","markersize",8,"markerfacecolor",[0.3,0.3,0.7],
		t, -t*vect_pesos(1)/vect_pesos(2) - (umbral/vect_pesos(2)), "linewidth",2.5, "color", [0.4,0.4,0.4],
		t, -t*vect_pesos(1)/vect_pesos(2) - ((umbral+1.0)/vect_pesos(2)), "linewidth",1.5,
		t, -t*vect_pesos(1)/vect_pesos(2) - ((umbral-1.0)/vect_pesos(2)), "linewidth",1.5,
		s1(:,1),s1(:,2), "+", "markersize", 18, "color", "black",
		s2(:,1),s2(:,2), "x", "markersize", 15, "color", "black");

	# rotular los puntos con sus valores de alfa y tolerancia nulos
	for i = 1:rows(data)
		if (length(find(res.v_indices ==i)) == 0)
			text(data(i,1)+0.15,data(i,2),	sprintf("0.00"),"FontSize", 10)
			text(data(i,1)-0.07,data(i,2)+0.3,sprintf("0.00"),"FontSize", 10)
		endif
	endfor

	#rotular los puntso con sus valores de alfa y tolerancias no nulos
	for i = 1:rows(res.sv_indices)
		text(data(res.sv_indices(i), 1)+0.15, data(res.sv_indices(i),2),
		sprintf("%4.2f",z(i)), "FontSize", 10)
		text(data(res.sv_indices(i),1)-0.07, data(res.sv_indices(i),2)+0.3,
		sprintf("%4.2f", abs(res.sv_coef(i))),"FontSize",10)
	endfor

	text(0.4, 0.65, sprintf("C = %4.2f", c), "FontSize", 10);
	text(0.4, 0.35, sprintf("marg = %4.2f", 2/norm(w)), "FontSize", 10);
	title(sprintf("data: %s, C = %4.2f, margin = %4.2f",
		dataFileName, c, 2/norm(w)));

	axis([0.7,0.7], "equal");
	grid on;

print -dps -color plotSWM.eps;

pause
end
