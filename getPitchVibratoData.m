function [vibratoDepth, vibratoRate, intervalSize, pp]=getPitchVibratoData(cents,sr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [vibratoDepth, vibratoRate, noteDynamics, intervals]
%    =getPitchVibratoDynamicsData(times,sr)
%
% Description: Calculate vibrato depth, vibrato rate, perceived pitch, and
%              interval size for the notes in the inputted cell array cents
%
% Inputs:
%  cents - cell array of cent values for each note 
%  sr - sampling rate
%
% Outputs:
%  vibratoDepth - cell array of vibrato depth calculations for each note
%  vibratoRate - cell array of vibrato rate calculations for each note
%  intervalSize - cell array of interval size calculations between
%                 sequential notes
%  pp - cell array of perceived pitch calculations for each note
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate vibrato depth, vibrato rate, and percieved pitch for each note
for i = 1 : length(cents)
    pp(i)=perceivedPitch(cents{i}, 1/sr*32, 100000);
    vibrato{i}=fft(cents{i});
    vibrato{i}(1)=0;
    vibrato{i}(round(end/2):end) = 0;
    [vibratoDepth(i) noteVibratOpos(i)] = max(abs(vibrato{i}));
    vibratoRate(i) = noteVibratOpos(i) * (44100/32) / length(vibrato{i});
end

% calculate interval size from sequential notes' perceived pitch estiamtes
for i=1 : length(pp)-1
    intervalSize(i) = pp(i+1)*1200-pp(i)*1200;
end