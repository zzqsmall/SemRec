function [ w ] = SemRec_All( uir, pr, palpha )
% predicted rating is calculated as the weighted average of confidences of
% different rating.

    pathCnt = size(pr,2);
    ratingCnt = size(pr,1);
    
    if ratingCnt==0
        w = ones(1, pathCnt) ./ pathCnt;
        return;
    end

    H = pr'*pr ./ ratingCnt + palpha.*eye(pathCnt);    
    f = -uir(:,3)'*pr ./ ratingCnt;
    A = [];
    b = [];
    Aeq = ones(1,pathCnt);
    beq = 1.0;
    lb = zeros(1,pathCnt);
    ub = ones(1,pathCnt);
    x0 = [];
    options = optimset('Display', 'off', 'Algorithm','interior-point-convex');
    
    [ w, fval ] = quadprog(H, f, A, b, Aeq, beq, lb, ub, x0, options);
    %[ w, fval ] = quadprog(H, f, A, b, [], [], [], [], [], options);
    w(w<0) = 0;
    
end
