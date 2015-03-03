function [ paths, pathsname ] = getYelpPaths(  )

    paths = cell(1,5);
    paths{1} = [ 6 -6; 7 -7; 8 -8; 9 -9; 10 -10 ]; %pUBU
    paths{2} = [ 2 -2 ]; %pUUU
    paths{3} = [ 3 -3 ]; %pUCU
    paths{4} = [ 6 4 -4 -6; 7 4 -4 -7; 8 4 -4 -8; 9 4 -4 -9; 10 4 -4 -10 ]; % pUM{CA}MU
    paths{5} = [ 6 5 -5 -6; 7 5 -5 -7; 8 5 -5 -8; 9 5 -5 -9; 10 5 -5 -10 ]; % pUMCMU
    
    pathsname = {'User-(i)-Business-(j)User_i=j','User-User-User',...
        'User-Compliment-User','User-(i)-Business-Category-Business-(j)-User_i=j','User-(i)-Business-City-Business-(j)-User_i=j'};

end
