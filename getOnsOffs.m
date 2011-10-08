function res=getOnsOffs(onsoffs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% res=getOnsOffs(onsoffs)
%
% Description: Extracts a list of onset and offset from an inputted 
%              3*N matrix of states and corresponding ending times 
%              from AMPACT's HMM-based alignment algorithm
%
% Inputs:
%  onsoffs - a 3*N alignment matrix, the first row is a list of N states
%            the second row is the time which the state ends, and the
%            third row is the state index
%
% Outputs:
%  res.ons - list of onset times
%  res.offs - list of offset times
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stopping=find(onsoffs(1,:)==3);
starting=stopping-1;

for i = 1 : length(starting)
    res.ons(i)=onsoffs(2,starting(i));
    res.offs(i)=onsoffs(2,stopping(i));
end