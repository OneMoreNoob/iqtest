#!/usr/bin/octave

% data/spam

tr= load('data/spam/tr.dat');
trlabels = load('data/spam/trlabels.dat');
ts= load('data/spam/ts.dat');
tslabels = load('data/spam/tslabels.dat');

nElementsTest = rows(tslabels);

for C = [0.01, 0.1, 1, 10, 100]
    
    for kernel = 0:3

        if kernel == 1
            
            for d = [2,3]
                res = svmtrain(trlabels, tr, ["-t 1 -d ", num2str(d), " -c ", num2str(C)]);

            end

        else
            res = svmtrain(trlabels, tr, ["-t ", num2str(kernel), " -c ", num2str(C)]);
        end

        [predicted_labels, accuracy] = svmpredict(tslabels, ts, res);
        acc = accuracy(1) / 100
        err = 1 - acc
        confidence = 1.96*sqrt(acc*err/nElementsTest)

    end

end