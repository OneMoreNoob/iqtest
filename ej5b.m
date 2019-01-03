#!/usr/bin/octave

load('data/usps/tr.dat');
load('data/usps/trlabels.dat');
load('data/usps/ts.dat');
load('data/usps/tslabels.dat');

res = svmtrain(trlabels, tr, ['-t 2 -c 10 -q']);
imshow(reshape(tr(res.sv_indices(10), :), 16, 16)')
print -dps -color svm1.eps;
pause();
imshow(reshape(tr(res.sv_indices(310), :), 16, 16)')
print -dps -color svm2.eps;
pause();
imshow(reshape(tr(res.sv_indices(510), :), 16, 16)')
print -dps -color svm3.eps;
pause();
imshow(reshape(tr(res.sv_indices(720), :), 16, 16)')
print -dps -color svm4.eps;
pause();
