#!/usr/bin/octave

% data/usps

load('data/usps/tr.dat');
load('data/usps/trlabels.dat');
load('data/usps/ts.dat');
load('data/usps/tslabels.dat');

nElementsTest = rows(tslabels);


for C = [0.01, 0.1, 1, 10, 100 ]
    C
    for kernel = 0:3
        kernel
        if kernel == 1
            
            for d = [2,3]
                d
                res = svmtrain(trlabels, tr, ["-q -t 1 -d ", num2str(d), " -c ", num2str(C)]);
                [predicted_labels, accuracy, decission_values] = svmpredict(tslabels, ts, res, '');
                acc = accuracy(1) / 100
                err = 1 - acc
                confidence = 1.96*sqrt(acc*err/nElementsTest)
				vectores = res.SVs
				for v = vectores'
					x = reshape(v,16,16);
					imshow(x')
					pause();
				endfor
            end

        else
            res = svmtrain(trlabels, tr, ["-q -t ", num2str(kernel), " -c ", num2str(C)]);
            [predicted_labels, accuracy, decission_values] = svmpredict(tslabels, ts, res, '');
            acc = accuracy(1) / 100
            err = 1 - acc
            confidence = 1.96*sqrt(acc*err/nElementsTest)
			vectores = res.SVs
				for v = vectores'
					x = reshape(v,16,16);
					imshow(x')
					pause();
				endfor
        end
        

    end

end
