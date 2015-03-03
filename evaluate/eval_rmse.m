function [ rmse ] = eval_rmse( pred_rating, real_rating, type )

    if nargin==3
        if strcmp(type,'l') || strcmp(type,'b')
            pred_rating(pred_rating<1)=1;
        end
        if strcmp(type,'r') || strcmp(type,'b')
            pred_rating(pred_rating>5)=5;
        end
    end

    rmse = mean((pred_rating-real_rating).^2).^0.5;

end