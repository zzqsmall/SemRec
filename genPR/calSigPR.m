function [ trainPR, testPR, simMat_t ] = calSigPR( path, alg, Rnorm, R, rtrain, ctrain, rtest, ctest, relationCnt, ratingLevel)
    % calculate the User Similarity.
    if strcmp(alg,'pcrw')
        simMat_t = runPCRW(Rnorm, path);
    elseif strcmp(alg, 'hetersim')
        simMat_t = runHeteSim(Rnorm, path);
    elseif strcmp(alg, 'pathsim')
        simMat_t = runPathSim(R, path);
    elseif strcmp(alg, 'pathcount')
        simMat_t = runPathCount(R, path);
    end
    
    [r,c,v] = find(simMat_t);
    fprintf('%.8f\t%.8f\n',mean(v),length(v)/size(simMat_t,1)/size(simMat_t,2));
    clear r c v
    
    trainRQ = zeros(length(rtrain), ratingLevel);
    testRQ = zeros(length(rtest), ratingLevel);
%    sumMat = sparse([], [], [], size(R{1},1), size(R{1},2));
    
    % calculate the Rating Confidence(RQ).
    for i = 1 : ratingLevel
        simMat = simMat_t * R{i+relationCnt};
%        sumMat = sumMat + simMat;
        %fprintf('%d : sparse = %.6fm\n', i, length(find(simMat)) / size(simMat,1) / size(simMat,2));
        
        idx = sub2ind(size(simMat), rtrain, ctrain);
        trainRQ(:,i) = simMat(idx);
    
        idx = sub2ind(size(simMat), rtest, ctest);
        testRQ(:,i) = simMat(idx);
    end
    
    % calculate the Predicted Rating(PR) along one meta path.
    trainPR = getPredictRating(trainRQ, ratingLevel);
    testPR = getPredictRating(testRQ, ratingLevel);

end

