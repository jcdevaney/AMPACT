function pp = perceivedPitch(f0s, sr, gamma)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pp = perceivedPitch(f0s, sr, gamma)
%
% Description: Calculate the perceived pitch of a note based on 
%               Gockel, H., B.J.C. Moore,and R.P. Carlyon. 2001. 
%               Influence of rate of change of frequency on the overall 
%               pitch of frequency-modulated Tones. Journal of the 
%               Acoustical Society of America. 109(2):701?12.
%
% Inputs:
%  f0s - vector of fundamental frequency estimates
%  sr - 1/sample rate of the f0 estimates (e.g. the hop rate in Hz of yin)
%  gamma - sets the relative weighting of quickly changing vs slowly 
%          changing portions of  notes. - a high gamma (e.g., 1000000)  
%          gives more weight to slowly changing portions.
%
% Outputs:
%  res.ons - list of onset times
%  res.offs - list of offset times
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('gamma', 'var'), gamma = 100000; end

% remove all NaNs in the f0 vector
f0s(isnan(f0s))=[];

% 
deriv = [diff(f0s)*sr -100];

%
weights = exp(-gamma * abs(deriv));

% calculate the perceived pitch as 
pp = f0s(:)' * weights(:) / sum(weights);