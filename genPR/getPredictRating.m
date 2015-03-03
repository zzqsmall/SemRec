function [ pr ] = getPredictRating( rq, ratingLevel )
    sum_rq = sum(rq,2);
    sum_rq(sum_rq==0) = 1; 
    norm_rq = rq.*repmat(1./sum_rq, [1,ratingLevel]);
    pr = norm_rq * (1:ratingLevel)';
end

