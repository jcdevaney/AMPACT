function trans = filltransmat(transseed, notes)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trans = filltransmat (transseed, notes)
%
% Description: 
%   Makes a transition matrix from a seed transition matrix.  The seed
%   matrix is composed of the states: steady state, transient, silence,
%   transient, steady state, but the full transition matrix starts and
%   ends with silence, so the seed with be chopped up on the ends.
%   Notes is the number of times to repeat the seed.  Transseed's first
%   and last states should be equivalent, as they will be overlapped
%   with each other.
%
% Inputs:
%   transseed - transition matrix seed
%   notes - number of notes being aligned
%
% Outputs: 
%   trans - transition matrix
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up transition matrix
N = size(transseed,1);
trans = zeros(notes*(N-1)+1,notes*(N-1)+1);
Non2 = ceil(N/2);

% Fill in first and last parts of the big matrix with the
% appropriate fragments of the seed
trans(1:Non2, 1:Non2) = transseed(Non2:end, Non2:end);
trans(end-Non2+1:end, end-Non2+1:end) = transseed(1:Non2, 1:Non2);

% Fill in the middle parts of the big matrix with the whole seed
for i = Non2 : N-1 : (notes-1)*(N-1)+1 - Non2+1
  trans(i+(1:N)-1,i+(1:N)-1) = transseed;
end
