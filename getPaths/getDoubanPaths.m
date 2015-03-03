function [ paths ] = getDoubanPaths(  )

    paths = cell(1,5);
    paths{1} = [ 8 -8; 9 -9; 10 -10; 11 -11; 12 -12 ]; %pUMU
    paths{2} = [ 3, -3 ]; %pUGU
    paths{3} = [ 8 5 -5 -8; 9 5 -5 -9; 10 5 -5 -10; 11 5 -5 -11; 12 5 -5 -12 ]; % pUMDMU
    paths{4} = [ 8 6 -6 -8; 9 6 -6 -9; 10 6 -6 -10; 11 6 -6 -11; 12 6 -6 -12 ]; % pUMAMU
    paths{5} = [ 8 7 -7 -8; 9 7 -7 -9; 10 7 -7 -10; 11 7 -7 -11; 12 7 -7 -12 ]; % pUMTMU

end
