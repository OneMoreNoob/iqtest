#!/usr/bin/octave -qf

#### SEPARAR UN CONJUNTO DE ENTRENAMIENTO Y OTRO DE TEST ####
load('data/usps/tr.dat');           # training
load('data/usps/trlabels.dat');
load('data/usps/ts.dat');           # test
load('data/usps/tslabels.dat');

#### EXTRAER LOS DATOS DE LAS CLASES 0 A 3 ####
posiciones_0 = find(trlabels == 0);
data_0 = tr(posiciones_0, :);
labels_0 = trlabels(posiciones_0, :);
posiciones_1 = find(trlabels == 1);
data_1 = tr(posiciones_1, :);
labels_1 = trlabels(posiciones_1, :);
posiciones_2 = find(trlabels == 2);
data_2 = tr(posiciones_2, :);
labels_2 = trlabels(posiciones_2, :);
posiciones_3 = find(trlabels == 3);
data_3 = tr(posiciones_3, :);
labels_3 = trlabels(posiciones_3, :);

posiciones_test = find(tslabels < 4);
data_test = ts(posiciones_test, :);
labels_test = tslabels(posiciones_test, :);

#### CLASIFICADORES 1vs1 Y PREDICCIONES ####

# 0 vs 1
data_01 = [data_0; data_1];
labels_01 = [labels_0; labels_1];
nrows = rows(data_01);
rand("seed", 27);
perm = randperm(nrows);
data_01 = data_01(perm, :);
labels_01 = labels_01(perm, :);
res_01 = svmtrain(labels_01, data_01, "");

# 0 vs 2
data_02 = [data_0; data_2];
labels_02 = [labels_0; labels_2];
nrows = rows(data_02);
rand("seed", 27);
perm = randperm(nrows);
data_02 = data_02(perm, :);
labels_02 = labels_02(perm, :);
res_02 = svmtrain(labels_02, data_02, "");

# 0 vs 3
data_03 = [data_0; data_3];
labels_03 = [labels_0; labels_3];
nrows = rows(data_03);
rand("seed", 27);
perm = randperm(nrows);
data_03 = data_03(perm, :);
labels_03 = labels_03(perm, :);
res_03 = svmtrain(labels_03, data_03, "");

# 1 vs 2
data_12 = [data_1; data_2];
labels_12 = [labels_1; labels_2];
nrows = rows(data_12);
rand("seed", 27);
perm = randperm(nrows);
data_12 = data_12(perm, :);
labels_12 = labels_12(perm, :);
res_12 = svmtrain(labels_12, data_12, "");

# 1 vs 3
data_13 = [data_1; data_3];
labels_13 = [labels_1; labels_3];
nrows = rows(data_13);
rand("seed", 27);
perm = randperm(nrows);
data_13 = data_13(perm, :);
labels_13 = labels_13(perm, :);
res_13 = svmtrain(labels_13, data_13, "");

# 2 vs 3
data_23 = [data_2; data_3];
labels_23 = [labels_2; labels_3];
nrows = rows(data_23);
rand("seed", 27);
perm = randperm(nrows);
data_23 = data_23(perm, :);
labels_23 = labels_23(perm, :);
res_23 = svmtrain(labels_23, data_23, "");

# predict
predicted_labels_01 = svmpredict(labels_test, data_test, res_01);
predicted_labels_02 = svmpredict(labels_test, data_test, res_02);
predicted_labels_03 = svmpredict(labels_test, data_test, res_03);
predicted_labels_12 = svmpredict(labels_test, data_test, res_12);
predicted_labels_13 = svmpredict(labels_test, data_test, res_13);
predicted_labels_23 = svmpredict(labels_test, data_test, res_23);

labels = [predicted_labels_01 predicted_labels_02 predicted_labels_03 predicted_labels_12 predicted_labels_13 predicted_labels_23];

#### CLASIFICADOR POR VOTACION DE 4 CLASES ####
votes = [];
votes = mode(labels')'; # cual se repite mas

n_elements = rows(labels);
correct_predictions_votes = sum(votes == labels_test);

accuracy_votes = correct_predictions_votes / n_elements


####  CLASIFICADOR DAG DE 4 CLASES ####
dag = zeros(n_elements, 1);
for x = 1:n_elements
    if labels(x,1) == 0             # 0vs1: clasificado como 0
        if labels(x,2) == 0         # 0vs2: clasificado como 0
            if labels(x,3) == 0     # 0vs3: clasificado como 0  DEFINITIVO
                dag(x,1) = 0;
            else                    # 0vs3: clasificado como 3  DEFINITIVO
                dag(x,1) = 3;
            endif
        else                        # 0vs2: clasificado como 2
            if labels(x,6) == 2     # 2vs3: clasificado como 2  DEFINITIVO
                dag(x,1) = 2;

            else                    # 2vs3: clasificado como 3  DEFINITIVO
                dag(x,1) = 3;
            endif
        endif

    else                            # 0vs1: clasificado como 1
        if labels(x,4) == 1         # 1vs2: clasificado como 1
            if labels(x,5) == 1     # 1vs3: clasificado como 1  DEFINITIVO
                dag(x,1) = 1;

            else                    # 1vs3: clasificado como 3  DEFINITIVO
                dag(x,1) = 3;
            endif

        else                        # 1vs2: clasificado como 2
            if labels(x,6) == 2     # 2vs3: clasificado como 2  DEFINITIVO
                dag(x,1) = 2;

            else                    # 3vs3: clasificado como 3  DEFINITIVO
                dag(x,1) = 3;
            endif
        endif
    endif

end


correct_predictions_dag = sum(dag == labels_test);

accuracy_dag = correct_predictions_dag / n_elements

#### COMPARAR LOS MEJORES RESULTADOS OBTENIDOS ####