function [x_mids y_mids] = findMids(x, mins, maxes, windowLength_ms, sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mids = findMids(x, mins, maxes, windowLength_ms, sr)
%
% Description: Find the midpoints between mins and maxes in a signal x.
%              mins and maxes could come from findPeaks.  Finds the y 
%              values of peaks and then finds the x values of the signal 
%              that are closest to the average between the min and max 
%              peak.
%
% Inputs:
%  x - inputted signal in cents
%  mins - indices of minima of x
%  maxes - indices of maxima of x
%  windowLength_ms - window length in miliseconds
%  sr - sampling rate of x (frame rate of frequency analysis)
%
% Outputs:
%  x_mids - midpoint locations in x axis between peaks and troughs  
%  y_mids - midpoint locations in y axis between peaks and troughs  
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% window length in frames
windowLength = round(windowLength_ms * sr / 2000) * 2;

% sort the peaks
pks = sort([maxes mins]);

% average the frequency estimate of the points around each peak
for i = 1:length(pks)
    idx = max(pks(i)-windowLength/2, 1) : ...
          min(pks(i)+windowLength/2, length(x));
    neighborhoods(i) = mean(x(idx));
end

% find the mid-points in frequency between peaks
y_mids = (neighborhoods(1:end-1) + neighborhoods(2:end)) / 2;

% find the index of the point in the signal between each peak with its
% value closest to the mid-point in frequency
for i = 1:length(y_mids)
    idx = pks(i):pks(i+1);
    [d offset] = min(abs(y_mids(i) - x(idx)));
    x_mids(i) = pks(i) + offset - 1;
end