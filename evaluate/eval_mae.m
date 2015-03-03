function [ mae ] = eval_mae( pred_rating, real_rating, type )

    if nargin==3
        if strcmp(type,'l') || strcmp(type,'b')
            pred_rating(pred_rating<1)=1;
        end
        if strcmp(type,'r') || strcmp(type,'b')
            pred_rating(pred_rating>5)=5;
        end
    end

    mae = mean(abs(pred_rating-real_rating));

end