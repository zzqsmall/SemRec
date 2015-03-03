function [te_rmse, te_mae] = eff_SemRec_Sig(dsprefix, dsradio, algname, fold, pathset)

addpath('./evaluate');
addpath('./prediction');

pathCnt = length(pathset);

te_rmse = zeros(fold,pathCnt);
te_mae = zeros(fold,pathCnt);

tic;

for k = 1:fold

    dsname = sprintf('%s/%d/%s_%d.mat', dsprefix, dsradio, algname, k);
    ds = load(dsname);
    teuir = ds.testUIR;
    tepr = ds.testPR(:, pathset);
    
    for i = 1:pathCnt
        w = zeros(1,pathCnt);
        w(1,i) = 1.0;
        
        pred_trr = prediction_all(teuir, tepr, w);
        te_rmse(k,i) = eval_rmse(pred_trr, teuir(:,3),'b');
        te_mae(k,i) = eval_mae(pred_trr, teuir(:,3),'b');
    end    
end
for i = 1:pathCnt
    fprintf('%d\t%.4f/%.4f\n', pathset(i), mean(te_rmse(:,i)), mean(te_mae(:,i)));
end

toc;

% if outputflag==true
%     outputfd = fopen(outputfn,'w');
%     for i = 1:pathcnt
%         fprintf(outputfd, '%.4f\t%.4f\n', mean(test_rmse(:,i)), mean(test_mae(:,i)));
%     end
% end

end
