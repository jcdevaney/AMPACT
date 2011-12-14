function steady = findSteady(x, mins, maxes, x_mids, y_mids, thresh_cents)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% steady = findSteady(x, mins, maxes, x_mids, y_mids, thresh_cents)
%
% Description: Find the steady-state portion of a note.
%              Finds the section of the note with steady vibrato where the 
%              peaks and troughs are at least thresh_cents cents away from 
%              the mid points between them.  mins and maxes come from 
%              findPeaks, x_mids and y_mids come from findMids.  Steady is 
%              a range of two indices into f0. mins and maxes may come from
%              the findPeaks function and x_mids and y_mids may come from
%              the findMids function.
%
% Inputs:
%  x - vector of f0 estimates in cents
%  mins - indices of minima of x
%  maxes - indices of maxima of x
%  x_mids - midpoint locations in x axis between peaks and troughs  
%  y_mids - midpoint locations in y axis between peaks and troughs  
%  thresh_cents - minimum distance in cents from midpoint for peaks and
%                 troughs
%
% Outputs:
%  steady - steady-state portion of inputted signal x
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find extrema that are far enough away from the midpoints
peaks = sort([mins maxes]);
excursion = y_mids - x(peaks(1:end-1));
bigEnough = abs(excursion) >= thresh_cents;

% Count how many extrema are big enough in a row
inARow(1) = double(bigEnough(1));
for i = 2:length(bigEnough)
    if bigEnough(i)
        inARow(i) = inARow(i-1)+1;
    else
        inARow(i) = 0;
    end
end

% Extract the portion of the note corresponding to the longest run of big
% enough extrema
[times pos] = max(inARow);
steadyPeaks = peaks([pos-times+1 pos]);
steady = x_mids([find(x_mids > steadyPeaks(1), 1), ...
                 find(x_mids < steadyPeaks(2), 1, 'last')]);
steady = round(steady);