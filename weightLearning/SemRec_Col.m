function [ weight, iter_cnt ] = SemRec_Col( sim_mat, truir, trpr, teuir, tepr, ucnt, icnt, parameters)
    
    [rcnt, pcnt] = size(trpr);
    
    % parameters setting.
    lambda0 = parameters(1);
    lambda1 = parameters(2);
    lr = parameters(3);
    eps = parameters(4);
    max_iter_cnt = parameters(5);
    
    % row-based normalization on sim_mat
    for i = 1:length(sim_mat)
        tmp = full(sum(sim_mat{i},2) + (sum(sim_mat{i},2)==0));
        sim_mat{i} = spdiags(1./tmp, 0, ucnt, ucnt) * sim_mat{i};
    end
    
    % weight learning
    pre_err = 1e10;
    iter_cnt = 0;
    weight = normrnd(0,0.025,ucnt,pcnt);
    pre_weight = weight;
    
    trmat = sparse(truir(:,1),truir(:,2),truir(:,3),ucnt,icnt);
    pred_sig_trmat = cell(1,pcnt);
    for i = 1:pcnt
        pred_sig_trmat{i} = sparse(truir(:,1),truir(:,2),trpr(:,i),ucnt,icnt);
    end
    pred_all_trmat = sparse(truir(:,1),truir(:,2),sum(trpr.*weight(truir(:,1),:),2),ucnt,icnt);
    while 1        
        for i = 1:pcnt
            err_term = -(sum((trmat-pred_all_trmat).*pred_sig_trmat{i},2));
            wreg_term = lambda0 .* weight(:,i);
            
            %[u,v,s] = find(sim_mat{i});
            %t = lambda1 .* sum(sparse(u,v,s.*(weight(u,i)-weight(v,i)),ucnt,ucnt),2) - ...
            %    lambda1 .* sum(sparse(u,v,s.*(weight(u,i)-weight(v,i)),ucnt,ucnt),1)';
            
            sreg_term = lambda1 .* (weight(:,i) - sim_mat{i}*weight(:,i)) - ...
                lambda1 .* sim_mat{i}' * (weight(:,i)-sim_mat{i}*weight(:,i));
            weight(:,i) = weight(:,i) - lr.*(err_term+wreg_term+sreg_term);
        end
        iter_cnt = iter_cnt + 1;
        
        pred_all_trmat = sparse(truir(:,1),truir(:,2),sum(trpr.*weight(truir(:,1),:),2),ucnt,icnt);
        cur_err = 1/2 .* sum(sum(sum((trmat-pred_all_trmat).^2))) + lambda0/2 .* sum(sum(weight.^2));
        for i = 1:pcnt
            %[u,v,s] = find(sim_mat{i});
            cur_err = cur_err + lambda1/2 .* sum((weight(:,i) - sim_mat{i}*weight(:,i)).^2);
        end
        
        w_del = abs(pre_weight-weight);
        
        if cur_err > pre_err
            fprintf('Error! cur_err>pre_err!\n');
        end
        if mean(mean(w_del)) < eps
            fprintf('Finish! Covergence!\n');
            break;
        end
        if iter_cnt > max_iter_cnt
            fprintf('Finish! Exceed max iteration count!\n');
            break;
        end
        
        pred_trr = prediction_ind(truir, trpr, weight);
        tr_rmse = eval_rmse(pred_trr,truir(:,3),'b');
        tr_mae = eval_mae(pred_trr, truir(:,3),'b');
        pred_ter = prediction_ind(teuir, tepr, weight);
        te_rmse = eval_rmse(pred_ter,teuir(:,3),'b');
        te_mae = eval_mae(pred_ter,teuir(:,3),'b');
        fprintf('%d\t%.6f\t%.6f\t%.4f\t%.4f\t%.4f\t%.4f\n',...
            iter_cnt,cur_err,mean(mean(w_del)),...
            tr_rmse,tr_mae,te_rmse,te_mae);
        
        pre_err = cur_err;
        pre_weight = weight;
    end
end

