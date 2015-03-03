function [ weight ] = eff_SemRec_Ind( dsname, dsratio, algname, fold, parameters, pathsetname, is_savemodel, model_filename )

    % reset random seed & add paths
    reset(RandStream.getGlobalStream);
    addpath('./weightLearning');
    addpath('./genPR');
    addpath('./evaluate');
    addpath('./similarity');
    addpath('./prediction');
    addpath('./getPaths');
    
    pathset = eval(pathsetname);
    
    % get rating count.
    data = load(sprintf('./data/%s.mat',dsname), 'relation');
    relation = data.relation;
    rcnt = length(find(relation{1}));
    [ucnt,icnt] = size(relation{1});
    clear relation;
    
    tr_rmse = zeros(1,fold);
    tr_mae = zeros(1,fold);
    te_rmse = zeros(1,fold);
    te_mae = zeros(1,fold);
    
    % training/test data partition, weight learning & evaluation
    for i = 1:fold
        if is_savemodel
            ord = randperm(rcnt);
            tr_rcnt = round(dsratio/100*rcnt);
            trord = ord(1:tr_rcnt);
            teord = ord(tr_rcnt+1:rcnt);        
            [truir, trpr, teuir, tepr, sim_mat] = genPR(trord, teord, pathset, dsname, algname, true);
            sim_mat = pruning(sim_mat, parameters(5));
            save(sprintf('data/tmp/%s.mat',model_filename),'truir','trpr','teuir','tepr','sim_mat');
        end
        
        load(sprintf('data/tmp/%s.mat',model_filename));
        
        [weight, iter_cnt] = SemRec_Ind(sim_mat, truir, trpr, teuir, tepr, ucnt, icnt, parameters);
        
        if is_savemodel
            save(sprintf('data/tmp/%s.mat',model_filename),'weight','-append');
        end
        
        pred_trr = prediction_ind(truir, trpr, weight);
        tr_rmse(i) = eval_rmse(pred_trr,truir(:,3),'b');
        tr_mae(i) = eval_mae(pred_trr, truir(:,3),'b');
        pred_ter = prediction_ind(teuir, tepr, weight);
        te_rmse(i) = eval_rmse(pred_ter,teuir(:,3),'b');
        te_mae(i) = eval_mae(pred_ter,teuir(:,3),'b');
        
        fprintf('%d\t#%d\t%.4f\t%.4f\t%.4f\t%.4f\n',...
            i, iter_cnt, tr_rmse(i), tr_mae(i), te_rmse(i), te_mae(i));
    end
    fprintf('avg\t%.4f\t%.4f\t%.4f\t%.4f\n',...
        mean(tr_rmse), mean(tr_mae), mean(te_rmse), mean(te_mae));
    
    save(sprintf('model_%d.mat',dsratio),'weight');
    
    fprintf('%-30s : %s\n','Method','SemRec_Ind');
    fprintf('%-30s : %s\n','Dataset',dsname);
    fprintf('%-30s : %d\n','Training data percentage',dsratio);
    fprintf('%-30s : %s\n','Similarity Measure',algname);
    fprintf('%-30s : %d\n','Fold', fold);
    fprintf('%-30s : %.2e\n','lambda0',parameters(1));
    fprintf('%-30s : %.2e\n','learning rate',parameters(2));
    fprintf('%-30s : %.2e\n','eps',parameters(3));
    fprintf('%-30s : %d\n','max iteration times',parameters(4));
    fprintf('%-30s : %.2e\n','pruning',parameters(5));
    
end

