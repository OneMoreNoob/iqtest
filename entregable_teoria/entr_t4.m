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

#### CLASIFICADOR POR VOTACION DE 4 CLASES ####
# 0 vs 1
res_01 = svmtrain([labels_0, labels_1], [data_0, data_1], "");

# 0 vs 2
res_02 = svmtrain([labels_0, labels_2], [data_0, data_2], "");

# 0 vs 3
res_03 = svmtrain([labels_0, labels_3], [data_0, data_3], "");

# 1 vs 2
res_12 = svmtrain([labels_1, labels_2], [data_1, data_2], "");

# 1 vs 2
res_12 = svmtrain([labels_1, labels_2], [data_1, data_2], "");

# 2 vs 3
res_23 = svmtrain([labels_2, labels_3], [data_2, data_3], "");

# predict
predicted_labels_01 = svmpredict(labels_test, data_test, res_01);
predicted_labels_02 = svmpredict(labels_test, data_test, res_02);
predicted_labels_03 = svmpredict(labels_test, data_test, res_03);
predicted_labels_12 = svmpredict(labels_test, data_test, res_12);
predicted_labels_13 = svmpredict(labels_test, data_test, res_13);
predicted_labels_23 = svmpredict(labels_test, data_test, res_23);

labels = [predicted_labels_01 predicted_labels_02 predicted_labels_03 predicted_labels_12 predicted_labels_13 predicted_labels_23];

votes = [];
votes = mode(labels')'; # cual se repite mas

n_elements = rows(labels);
correct_predictions = sum(votes == labels_test);

accuracy = correct_predictions / n_elements


####  CLASIFICADOR DAG DE 4 CLASES ####




#### COMPARAR LOS MEJORES RESULTADOS OBTENIDOS ####