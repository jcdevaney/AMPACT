function smoothed = smoothNote(x, x_mid, y_mid)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% smoothed = smoothNote(x, x_mid, y_mid)
%
% Description: Generate a smoothed trajectory of a note by connecting the
%              midpoints between peaks and troughs.
%
% Inputs:
%  x - inputted signal 
%  x_mid - midpoint locations in x axis between peaks and troughs  
%  y_mid - midpoint locations in y axis between peaks and troughs  
%
% Outputs:
%  smoothed - smoothed version of inputted signal x
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Make a note the same size as x
smoothed = zeros(size(x));

% But only populate it with non-zero elements between the x_mid values
x = min(x_mid) : max(x_mid);

% Interpolate the mid points at all of the sample points in the signal
smoothed(x) = interp1(x_mid, y_mid, x);