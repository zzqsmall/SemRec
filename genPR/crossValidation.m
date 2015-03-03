function [  ] = crossValidation( dsname, dsratio, pathsetname, algname, fold, outputpath )
% 1.generate train/test set
% 2.n-fold cross validation, default n=5
    addpath('../getPaths');
    addpath('../similarity');
    
    pathset = eval(pathsetname);
    
    ds = load(sprintf('../data/%s.mat',dsname));
    ratingCnt = length(find(ds.relation{1}));
    clear relation;

    for i = 1 : fold
        order = randperm(ratingCnt);
        trainCnt = round(dsratio/100*ratingCnt);
        trainOrder = order(1:trainCnt);
        testOrder = order(trainCnt+1:ratingCnt);
        
        tic;
        fprintf('fold: %d\n', i);
        [ trainUIR, trainPR, testUIR, testPR ] = genPR(trainOrder, testOrder, pathset, dsname, algname, false);
        
        toc;
        
        fa = sprintf('%s/%d/%s_%d.mat', outputpath, dsratio, algname, i);
        save(fa, 'trainUIR', 'trainPR', 'testUIR', 'testPR');
        
    end

end

