function [ truir, trpr, teuir, tepr, sim_mat ] = genPR( trord, teord, pathset, dsname, algname, has_simmat)
%GENSIMFEA Summary of this function goes here
%   Detailed explanation goes here
    ds = load(sprintf('~/Documents/project/SemRec/solution/src/data/%s.mat',dsname));
    relation = ds.relation;
    rl = ds.ratingLevel;
    clear ds;
    
    racnt = zeros(1,length(relation));
    for i = 1:length(relation)
        racnt(i) = max(relation{i}(:,3));
    end
    rcnt = length(relation)+sum(racnt(racnt>1));
    R = cell(1,rcnt);
    Rnorm = cell(2,rcnt);
    for i = 1:length(relation)        
        if i == 1
            [r,c] = find(relation{i});
            R{i} = sparse(r(trord),c(trord),ones(length(trord),1),size(relation{i},1),size(relation{i},2));
        else
            R{i} = relation{i};
        end
        Rnorm{1, i} = spdiags( 1 ./ (sum(R{i}, 2) + (sum(R{i}, 2)==0)), 0, size(R{i},1), size(R{i},1)) * R{i};
        Rnorm{2, i} = R{i} * spdiags( 1./ (sum(R{i}, 1) + (sum(R{i}, 1)==0))', 0, size(R{i},2), size(R{i},2));
    end
    for j = 1:length(racnt)
        if racnt(j) > 1
            [r,c,v] = find(relation{j});
            %[rnr,cnr,vnr] = find(Rnorm{1,j});
            %[rnc,cnc,vnc] = find(Rnorm{2,j});
            [ rcnt,ccnt ] = size(relation{j});
            for k = 1:racnt(j)
                i = i+1;
                tmpv = v(trord);
                tmpv(v(trord)~=k) = 0;
                tmpv(v(trord)==k) = 1;
                R{i} = sparse(r(trord),c(trord),tmpv,rcnt,ccnt);
                Rnorm{1,i} = Rnorm{1,j}.*R{i};
                Rnorm{2,i} = Rnorm{2,j}.*R{i};
                %Rnorm{1,i} = sparse(rnr,cnr,tmpv.*vnr,rcnt,ccnt);                
                %Rnorm{2,i} = sparse(rnc,cnc,tmpv.*vnc,rcnt,ccnt);
            end
        end
    end
    
     nrcnt = length(relation);
%     trCnt = length(relation)+ratingLevel*2-1;
%     R = cell(1, trCnt);
%     Rnorm = cell(2, trCnt);    
%     [ r,c,v ] = find(relation{1});
%     
% %    R{1} = sparse(r(trainOrder), c(trainOrder), v(trainOrder), size(relation{1},1), size(relation{1},2));
%     R{1} = sparse(r(trainOrder), c(trainOrder), ones(size(r(trainOrder))), size(relation{1},1), size(relation{1},2));
%     for i = 2 : length(relation)
%         R{i} = relation{i};
%     end
%     for i = 1 : ratingLevel
%         vtmp = v(trainOrder);
%         vtmp(vtmp ~= i) = 0;
%         vtmp(vtmp > 0) = 1;
%         R{length(relation)+i} = sparse(r(trainOrder), c(trainOrder), vtmp, size(relation{1},1), size(relation{1},2));
%     end
% 	for i = 1 : ratingLevel-1
% 		vtmp = v(trainOrder);
% 		vtmp(vtmp ~= i & vtmp ~= i+1) = 0;
% 		vtmp(vtmp > 0) = 1;
%         R{length(relation)+ratingLevel+i} = sparse(r(trainOrder), c(trainOrder), vtmp, size(relation{1},1), size(relation{1},2));
% 	end
%     
%     for i = 1 : length(R)
%         [ rcnt,ccnt ] = size(R{i});
%         Rnorm{1, i} = spdiags( 1 ./ (sum(R{i}, 2) + (sum(R{i}, 2)==0)), 0, rcnt, rcnt) * R{i};
%         Rnorm{2, i} = R{i} * spdiags( 1./ (sum(R{i}, 1) + (sum(R{i}, 1)==0))', 0, ccnt, ccnt );
%     end
    
    [r,c,v] = find(relation{1});
    truir = [r(trord) c(trord) v(trord)];
    teuir = [r(teord) c(teord) v(teord)];
    trpr = zeros(length(trord), length(pathset));
    tepr = zeros(length(teord), length(pathset));
    sim_mat = cell(1,length(pathset));
    
    for i = 1:length(pathset)
        if has_simmat
            [trpr(:,i), tepr(:,i), sim_mat{i}] = ... 
                calSigPR(pathset{i}, algname, Rnorm, R, r(trord), c(trord), r(teord), c(teord), nrcnt, rl);
        else
            [trpr(:,i), tepr(:,i)] = ... 
                calSigPR(pathset{i}, algname, Rnorm, R, r(trord), c(trord), r(teord), c(teord), nrcnt, rl);
        end
    end
end
