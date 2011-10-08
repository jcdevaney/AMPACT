function [vpath,startingState,prior,trans,meansFull,covarsFull,mixmat,obs,stateOrd] = runHMMAlignment(notenum, means, covars, align, yinres, sr, learnparams)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[vpath,startingState,prior,trans,meansFull,covarsFull,mixmat,obs,stateOrd]
% = runHMMAlignment(notenum, means, covars, align, yinres, sr, learnparams)
%
% Description: 
%   Refines DTW alignment values with a three-state HMM, identifying 
%   silence,transient, and steady state parts of the signal. The HMM  
%   uses the DTW alignment as a prior. 
%
% Inputs:
%   notenum - number of notes to be aligned
%   means - 3x2 matrix of mean aperiodicy and power values HMM states
%           column: silence, trans, steady state
%           rows: aperiodicity, power
%   covars - 3x2 matrix of covariances for the aperiodicy and power
%            values (as per means)
%   res - structure containing inital DTW aligment
%   yinres - structure containg yin analysis of the signal
%   sr - sampling rate of the signal
%
% Outputs: 
%   vpath - verterbi path
%   startingState - starting state for the HMM
%   prior - prior matrix from DTW alignment
%   trans - transition matrix
%   meansFull - means matrix
%   covarsFull - covariance matrix
%   mixmat - matrix of priors for GMM for each state
%   obs - two row matrix observations (aperiodicty and power)
%   stateOrd - modified state order sequence
%
% Dependencies:
%   Murphy, K. 1998. Hidden Markov Model (HMM) Toolbox for Matlab.
%    Available from http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org - Johanna Devaney, 2011
% (c) copyright 2011 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('learnparams', 'var'), shift = 0; end

% create vectors of onsets and offsets times from DTW alignment 
ons=floor(align.on*sr/32);
offs=floor(align.off*sr/32);

% create observation matrix
obs(1,:)=sqrt(yinres.ap(1:offs(notenum)+50));
obs(2,:)=sqrt(yinres.pwr(1:offs(notenum)+50));
obs(3,:)=69+12*yinres.f0(1:offs(notenum)+50); % convert octave to midi note

% replace any NaNs in the observation matrix with zeros
obs(isnan(obs))=0;

% refine the list of onsets and offsets according to the number of notes
% specified in the input arg 'not
prior_ons=ons(1:notenum);
prior_offs=offs(1:notenum);
notes = length(prior_ons);

% states: silence, trans, steady state
% rows: aperiodicity, power
stateOrdSeed = [1 2 3 2 1];
stateOrd = [repmat(stateOrdSeed(1:end-1),1,notes) stateOrdSeed(end)];

% use stateOrd to expand means and covars to each appearance
midiNotes = repmat(align.midiNote(1:notenum)', length(stateOrdSeed)-1, 1);
midiNotes = [midiNotes(:)' midiNotes(end)];
meansFull  = [means(:,stateOrd); midiNotes];

covars(3,3,1) = 100;
covars(3,3,2) = 5;
covars(3,3,3) = 1;
covarsFull = covars(:,:,stateOrd);

mixmat = ones(length(stateOrd),1);

% transititon matrix seed
% {steady state, transient, silence, transient, steady state}
transseed=zeros(5,5);
transseed(1,1)=.99;
transseed(2,2)=.98;
transseed(3,3)=.98;
transseed(4,4)=.98;
transseed(5,5)=.99;
transseed(1,2)=.0018;
transseed(1,3)=.0007;
transseed(1,4)=.0042;
transseed(1,5)=.0033;
transseed(2,3)=0.0018;
transseed(2,4)=0.0102;
transseed(2,5)=0.0080;
transseed(3,4)=0.0112;
transseed(3,5)=0.0088;
transseed(4,5)=0.02;

% call filltransmat to expand the transition matrix to the appropriate size
trans = filltransmat(transseed,notes);

% create starting state space matrix
startingState = [1; zeros(4*notes,1)];

% call fillpriormat_gauss to create a prior matrix
prior=fillpriormat_gauss(size(obs,2),prior_ons,prior_offs,5);

if learnparams
    % use the mhmm_em function from Kevin Murphy's HMM toolkit to
    % learn the HMM parameters
    save orig_hmm_params
    [LL, startingState, trans, meansFull, covarsFull, mixmat1] = ...
    mhmm_em(obs, startingState, trans, meansFull, covarsFull, mixmat, 'max_iter', 1, 'adj_prior', 0, 'adj_trans', 0, 'adj_mix', 0, 'cov_type', 'diag');
    save new_hmm_params
end

% create a likelihood matrix with the mixgauss_prob function from Kevin
% Murphy's HMM toolkit
like = mixgauss_prob(obs, meansFull, covarsFull, mixmat,1);

% use the veterbi path function from Kevin Murphy's HMM toolkit to find the
% most likely path
prlike=prior.*like;
clear like
vpath=viterbi_path(startingState, trans, prlike);
