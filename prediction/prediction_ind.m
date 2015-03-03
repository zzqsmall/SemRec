function [ pred_rating ] = prediction_ind( uir, pr, weight )
    
    %pred_rating = sum(pr.*weight(uir(:,1),:),2);
    [rcnt,pcnt] = size(pr);
    w = weight(uir(:,1),:);
    sumw1 = sum(w,2);
    w(pr==0) = 0;
    sumw2 = sum(w,2);
    w = w.*repmat(sumw1./(sumw2+(sumw2==0)),[1,pcnt]);
    pred_rating = sum(pr.*w,2);

end

