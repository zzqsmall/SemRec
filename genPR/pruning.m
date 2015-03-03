function [ sim_mat ] = pruning( sim_mat, radio )
    
    ucnt = size(sim_mat{1},1);
    k = floor(ucnt*radio);
    
    for i = 1:length(sim_mat)
        [vmat, imat] = sort(full(sim_mat{i}),2,'descend');
        vmat = vmat(:,1:k);
        imat = imat(:,1:k);
        s = reshape(vmat', [ucnt*k,1]);
        v = reshape(imat', [ucnt*k,1]);
        u = reshape(repmat((1:ucnt)',[1,k]), [ucnt*k,1]);
        sim_mat{i} = sparse(u,v,s,ucnt,ucnt);
    end


end

