#!/usr/bin/octave -qf

# data/mini

graphics_toolkit("gnuplot");

# conjunto separable

load('data/mini/trSep.dat');
load('data/mini/trSeplabels.dat');

# obtener SVM sin kernel
res = svmtrain(trlabels, tr, '-t 0 -c 1000');

# multiplicadores de Lagrange
mult_lagrange = res.sv_coef;
# vectores soporte
vect_soporte = res.SVs;
# vector de pesos
vect_pesos = mult_lagrange'*vect_soporte;
# umbral de la funcion
umbral = -res.rho;
# margen
margen = 1/(vect_pesos*vect_pesos');

# calcular parametros de la frontera lineal
m = - vect_pesos(1)/vect_pesos(2) ;
b = - umbral/vect_pesos(2);
b1 = - (umbral - 1) / vect_pesos(2);
b2 = - (umbral + 1) / vect_pesos(2);

# representar graficamente
# calcular unos cuantos valores de 'y' y 'x' para dibujar la recta

X  = [0:1:7];
Y  = m * X + b ;
Y1 = m * X + b1;
Y2 = m * X + b2;

plot(X, Y, X, Y1, X, Y2,
	tr(trlabels==1, 1), tr(trlabels==1, 2), 'x',
    tr(trlabels==2, 1), tr(trlabels==2, 2), 's',
    tr(res.sv_indices, 1), tr(res.sv_indices, 2), '+')
	axis([0,7,0,7]);
pause;


# conjunto no separable

load('data/mini/tr.dat');
load('data/mini/trlabels.dat');
for c=[0.01 0.1 1 10 100 1000]
   # obtener SVM sin kernel
	string = ['-t 0 -c ' num2str(c)];
    res = svmtrain(trlabels, tr, string); 
    # multiplicadores de Lagrange
    mult_lagrange = res.sv_coef;
    # vectores soporte
    vect_soporte = res.SVs;
    # vector de pesos
    vect_pesos = mult_lagrange'*vect_soporte;
    # umbral de la funcion
    umbral = -res.rho;
    # margen
    margen = 1/(vect_pesos*vect_pesos');

	# calcular parametros de la frontera lineal
	m = - vect_pesos(1)/vect_pesos(2) ;
	b = - umbral/vect_pesos(2);
	b1 = - (umbral - 1) / vect_pesos(2);
	b2 = - (umbral + 1) / vect_pesos(2);

	# representar graficamente
	# calcular unos cuantos valores de 'y' y 'x' para dibujar la recta

	X  = [0:1:7];
	Y  = m * X + b ;
	Y1 = m * X + b1;
	Y2 = m * X + b2;

	plot(X, Y, X, Y1, X, Y2,
	tr(trlabels==1, 1), tr(trlabels==1, 2), 'x',
    tr(trlabels==2, 1), tr(trlabels==2, 2), 's',
    tr(res.sv_indices, 1), tr(res.sv_indices, 2), '+');
	pause;

    # tolerancia de margen (diapositiva 4.17)
    tolerancia_margen_sv = (abs(mult_lagrange) == c) .* (1 - sign(mult_lagrange) .* (vect_soporte * vect_pesos' + umbral));
	tolerancia_margen = zeros(size(trlabels));
	tolerancia_margen(res.sv_indices) = tolerancia_margen_sv;
	multiplicadores_lagrange = zeros(size(trlabels));
	multiplicadores_lagrange(res.sv_indices) = res.sv_coef;

    #representar graficamente marcando los vectores erroneos

	plot(
		X, Y, 'g',
		X, Y1, 'b',
		X, Y2, 'r',
		tr(trlabels==1,1), tr(trlabels==1,2), 'sr',
		tr(trlabels==2,1), tr(trlabels==2,2), '.b',
		tr(tolerancia_margen!=0,1), tr(tolerancia_margen!=0,2), "xk",
		res.SVs(tolerancia_margen_sv==0,1),res.SVs(tolerancia_margen_sv==0,2), "+k"
	);
	
	pause();
endfor

