function [voices trans]=genPolyTrans(selfWeight, skip2Weight, skip1Weight)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [voices trans]=genPolyTrans(selfWeight, skip2Weight, skip1Weight)
%
% Description: Generate transition matrix for HMM
%
% Inputs:
%  selfWeight - relative weight given to self transitions
%  skip2Weight - relative weight given to transitions from 1->2 or 2->3
%  skip1Weight - relative weight given to transitions from 1->3
%
% Outputs:
%  voices - cell array of possible sequences
%  trans - transition matrix
%
% Dependencies:
%  None
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT)
% http://www.ampact.org
% (c) copyright 2014 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('selfWeight', 'var') || isempty(selfWeight), selfWeight = 5; end
if ~exist('skip1Weight', 'var') || isempty(skip1Weight), skip1Weight = 1; end
if ~exist('skip2Weight', 'var') || isempty(skip2Weight), skip2Weight = 1; end

idx = 1; 
for i = 1 : 3
    voices{1}{idx} = i;
    idx = idx + 1;
end

idx = 1; 
for i = 1 : 3
    for j = 1 : 3
        voices{2}{idx} = [i j]; 
        idx = idx + 1; 
    end
end

idx = 1; 
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            voices{3}{idx} = [i j k]; 
            idx = idx + 1; 
        end
    end
end

idx = 1; 
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            for m = 1 : 3
                voices{4}{idx} = [i j k m]; 
                idx = idx + 1; 
            end
        end
    end
end

idx = 1; 
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            for m = 1 : 3
                for n = 1 : 3
                    voices{5}{idx} = [i j k m n]; 
                    idx = idx + 1; 
                end
            end
        end
    end
end

idx = 1; 
for i = 1 : 3
    for j = 1 : 3
        for k = 1 : 3
            for m = 1 : 3
                for n = 1 : 3
                    for p = 1 : 3
                        voices{6}{idx} = [i j k m n p]; 
                        idx = idx + 1; 
                    end
                end
            end
        end
    end
end


for t = 1:length(voices)
    trans{t}=zeros(length(voices{t}));
    for i = 1 : size(trans{t},1)
        for j = i : size(trans{t},2)
            if sum(voices{t}{i}==voices{t}{j}) >= length(voices{t}{j})-1
                stateChange = max(voices{t}{j} - voices{t}{i});
                if stateChange == 2  % 1->3
                    trans{t}(i,j) = skip2Weight;
                elseif stateChange == 1  % 1->2 or 2->3
                    trans{t}(i,j) = skip1Weight;
                elseif stateChange == 0  % 1->1 or 2->2 or 3->3
                    trans{t}(i,j) = selfWeight;
                end
            end
        end
    end

    % Normalize
    trans{t} = bsxfun(@rdivide, trans{t}, sum(trans{t}, 2));

end
