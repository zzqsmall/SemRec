function [ pred_rating ] = prediction_all( uir, pr, w )

    if isempty(uir)
        pred_rating = [];
        return;
    end

    [rcnt,pcnt] = size(pr);
    
    % normalizing available path weights and make prediction.
    wmat = repmat(w, [rcnt, 1]).*(pr~=0);
    swmat = sum(wmat,2);
    swmat(swmat==0) = 1;
    wmat = wmat.*repmat(1./swmat, [1,pcnt]);
    pred_rating = sum(pr.*wmat,2);

    %pred_rating = pr*w';

end

