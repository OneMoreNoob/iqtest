#!/usr/bin/octave

% data/usps

tr= load('data/usps/tr.dat');
trlabels = load('data/usps/trlabels.dat');
ts= load('data/usps/ts.dat');
tslabels = load('data/usps/tslabels.dat');



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