function cents = hzcents(x1, x2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% y = hzcents(x1, x2)
%
% Description: Calculates the difference in cents between the frequencies
%              supplied in x1 and x2 using the formula: 
%                 cents = 1200 * log(x1/x2) / log 2
%              if x1 is higher than x2 the value in cents will be positive
%              if x1 is lower than x2 the value in cents will be negative
%
% Inputs:
%  x1 - frequency one in hertz
%  x2 - frequency two in hertz
%
% Outputs:
%  cents - size of the interval in cents between x1 and x2
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if x1 == 0 
    cents = 0
elseif x2 == 0
    cents = 0
else
    cents =  1200 * log(x2 ./ x1) ./ log(2);
end