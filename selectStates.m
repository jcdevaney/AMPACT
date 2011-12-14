function cumsumvals2=selectStates(startingState,prior,...
    trans,meansFull,covarsFull,mixmat,obs,stateO,noteNum,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [vpath2,histvals2,cumsumvals2]=selectStates(startingState,prior,trans,
%   meansFull,covarsFull,mixmat,obs,stateO,noteNum,sr)
%
% Description: 
%  Refines the HMM parameters according to the modified state 
%  sequence vector (stateO) passed into the function.
%
% Inputs:
%  startingState - starting state for the HMM
%  prior - prior matrix from DTW alignment
%  trans - transition matrix
%  meansFull - means matrix
%  covarsFull - covariance matrix
%  mixmat - matrix of priors for GMM for each state
%  obs - two row matrix observations (aperiodicty and power)
%  stateO - modified state order sequence
%  noteNum - number of notes to be aligned
%  sr - sampling rate
%
% Outputs: 
%  vpath2 - viterbi path
%  histvals2 - tally of the number of frames in each state
%  cumsumvals2 - ending time of each state in seconds 
%
% Dependencies:
%   Murphy, K. 1998. Hidden Markov Model (HMM) Toolbox for Matlab.
%    Available from http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create new versions the inputted variables based on the state sequence 
% StateO
vec = (stateO + (noteNum - 1)*4);
startingState2 = startingState(vec, :);
prior2 = prior(vec, :);
trans2 = trans(vec, vec);
trans2 = diag(1./sum(trans2,2))*trans2;
meansFull2 = meansFull(:,vec);
covarsFull2 = covarsFull(:,:,vec);
mixmat2 = mixmat(vec,:);

% calculate the likelihood and vitiberi path with the new variables
like2 = mixgauss_prob(obs, meansFull2, covarsFull2, mixmat2);
vpath2=viterbi_path(startingState2, trans2, prior2.*like2);

% create a vector of the modified alignment times 
histvals2 = hist(vpath2, 1:max(vpath2));
cumsumvals2 = cumsum(histvals2*32/sr);
