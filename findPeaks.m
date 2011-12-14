function [mins maxes] = findPeaks(x, windowLength_ms, sr, minCount)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [mins maxes] = findPeaks(x, windowLength_ms, sr, minCount)
%
% Description: Find peaks and troughs in a waveform
%              Finds the max and min in a window of a given size and keeps 
%              track of how many windows each point is the min or max of.  
%              Points that are the min or max of more than minCount windows
%              are returned.
%
% Inputs: 
%  x - inputted signal
%  windowLength_ms - window length in ms
%  sr - sampling rate
%  minCount - minimum number of windows that a point needs to be the max 
%             of to be considered a minimum or a maximum
%
% Outputs:
%  mins - minimum values in the signal
%  maxes - maximum values in the signal
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create a vector of zeros for mins and maxes
mins  = zeros(size(x));
maxes = zeros(size(x));

% calculate window length in frames
windowLength = windowLength_ms * sr / 1000;

% calculate the minimum and maximum value
for i = 1:length(x) - windowLength
    w = x(i:i+windowLength-1);
    [d di] = min(w);
    mins(i + di - 1) = mins(i + di - 1) + 1;
    [d di] = max(w);
    maxes(i + di - 1) = maxes(i + di - 1) + 1;
end

% pruns mins and maxes to only those that occur in an equal to or greater
% number windows specified in minCount
mins  = find(mins  >= minCount);
maxes = find(maxes >= minCount);