#!/usr/bin/octave

% data/spam

tr= load('data/spam/tr.dat');
trlabels = load('data/spam/trlabels.dat');
ts= load('data/spam/ts.dat');
tslabels = load('data/spam/tslabels.dat');

for C = [0.01, 0.1, 1, 10, 100]
    
    for kernel = 0:3

        if kernel == 1
            
            for d = [2,3]
                res = svmtrain();

            end

        else
            res = svmtrain();
        end

    end

end