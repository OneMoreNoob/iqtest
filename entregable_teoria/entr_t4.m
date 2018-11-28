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
res_01 = svmtrain([labels_0; labels_1], [data_0; data_1], "");

# 0 vs 2
res_02 = svmtrain([labels_0; labels_2], [data_0; data_2], "");

# 0 vs 3
res_03 = svmtrain([labels_0; labels_3], [data_0; data_3], "");

# 1 vs 2
res_12 = svmtrain([labels_1; labels_2], [data_1; data_2], "");

# 1 vs 3
res_13 = svmtrain([labels_1; labels_3], [data_1; data_3], "");

# 2 vs 3
res_23 = svmtrain([labels_2; labels_3], [data_2; data_3], "");

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