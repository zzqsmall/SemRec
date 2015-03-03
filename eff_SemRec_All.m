function [ test_rmse, test_mae, weight, train_rmse, train_mae ] = eff_SemRec_All(dsprefix, dsradio, algname, fold, palpha, pathset)
    
    addpath('./weightLearning/');
    addpath('./evaluate/');
    addpath('./prediction/');
    
    warning off;
    rand('state',sum(1000000*clock));

    fprintf('EffExp of SemRec_All### dsprefix=%s, SimAlg=%s, fold=%d, alpha=%.4f\n', ...
        sprintf('%s/%d/', dsprefix, dsradio), algname, fold, palpha);
    
    tic;

    pathCnt = length(pathset);
    
    test_rmse = zeros(1,fold);
    train_rmse = zeros(1,fold);
    test_mae = zeros(1,fold);
    train_mae = zeros(1,fold);
    weight = zeros(fold, pathCnt);

    for i = 1:fold
        dsname = sprintf('%s/%d/%s_%d.mat', dsprefix, dsradio, algname, i);
        ds = load(dsname);
        trainUIR = ds.trainUIR;
        testUIR = ds.testUIR;
        trainPR = ds.trainPR(:, pathset);
        testPR = ds.testPR(:, pathset);

        w = SemRec_All(trainUIR, trainPR, palpha)';
        %w = SemRec_All_v2(trainUIR,trainPR,testUIR,testPR,palpha,1e-4,1e-8,800);
        weight(i,:) = w';
        
        pred_trr = prediction_all(trainUIR, trainPR, w);
        train_rmse(i) = eval_rmse(pred_trr, trainUIR(:,3),'b');
        train_mae(i) = eval_mae(pred_trr, trainUIR(:,3),'b');
        
        pred_ter = prediction_all(testUIR, testPR, w);
        test_rmse(i) = eval_rmse(pred_ter, testUIR(:,3),'b');
        test_mae(i) = eval_mae(pred_ter, testUIR(:,3),'b');
        
%         [ train_rmse(i), train_mae(i) ] = rmsemae(trainUIR, trainPR, w);
%         [ test_rmse(i), test_mae(i) ] = rmsemae(testUIR, testPR, w);

        fprintf('train_%d : RMSE = %.4f, MAE = %.4f\n', i, train_rmse(i), train_mae(i));
        fprintf('test_%d  : RMSE = %.4f, MAE = %.4f\n', i, test_rmse(i), test_mae(i));
    end
    
    fprintf('train_avg : RMSE = %.4f, MAE = %.4f\n', mean(train_rmse), mean(train_mae));
    fprintf('test_avg  : RMSE = %.4f, MAE = %.4f\n', mean(test_rmse), mean(test_mae));
    toc;

end
