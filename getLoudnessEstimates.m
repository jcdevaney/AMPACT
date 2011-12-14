function [loudnessEstimates loudnessStructure]=getLoudnessEstimates(audiofile, times)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nmat=getTimingData(midifile, times)
%
% Description: Get loudness estimate based on Glasberg and Moore (2002)
%              for time-varying sounds using the Loudness Toolbox
%
% Inputs:
%  audiofile - name of audiofile
%  times - onset and offset times
%
% Outputs:
%  loudnessEstimates - maximum short-term loudness (in sones) vs time
%  loudnessStructure - complete structure returned by
%                      Loudness_TimeVaryingSound_Moore
%
% Dependencies:
%   Genesis Acoustics. 2010. Loudness Toolbox for Matlab.
%    Available from http://www.genesis-acoustics.com/index.php?page=32 
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) and Michael Mandel
%                    (mim@mr-pc.org), all rights reserved
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read audiofile
[sig,sr]=wavread(audiofile);

for i = 1 : length(times.ons)
    
    % get loudness estimate for time-vaying sounds based on Glasberg and
    % Moore (2002)
    loudnessStructure{i}=Loudness_TimeVaryingSound_Moore(sig(times.ons(i)*sr:times.offs(i)*sr),sr);
    
    % save the maximum short-term loudness (in sones) vs time in a seperate
    % variable
    loudnessEstimates(i)=loudnessStructure{i}.STLlevelmax;
    
end