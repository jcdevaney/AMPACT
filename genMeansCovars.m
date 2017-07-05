function [meansSeed covarsSeed versions]=genMeansCovars(notes, vals, voiceType)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [meansSeed covarsSeed versions]=genMeansCovars(notes, vals)
%
% Description: Generate seed means and covariances matrices for specified 
%              voice type
%
% Inputs:
%  notes - cell array of possible sequences
%  vals - mean and covariance values
%  voiceType - voice type (male or female)
%
% Outputs:
%  meansSeed - mean seed matrix
%  covarsSeed - covariance seed matrix
%  versions - possible sequences of states for the number of voices 
%
% Dependencies:
%   None
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT)
% http://www.ampact.org
% (c) copyright 2014 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% format of vals
% vals{:}{1}{:} - male
% vals{:}{2}{:} - female

numVoice = length(voiceType);

for i = 1 : numVoice
    noteMean1(i,1) = vals{1}{voiceType(i)}(1);
    noteMean1(i,2) = vals{2}{voiceType(i)}(1);
    noteMean1(i,3) = vals{2}{voiceType(i)}(1);
    noteCovar1(i,1) = vals{1}{voiceType(i)}(2);
    noteCovar1(i,2) = vals{2}{voiceType(i)}(2);
    noteCovar1(i,3) = vals{2}{voiceType(i)}(2);
    noteMean2(i,1) = vals{2}{voiceType(i)}(1);
    noteMean2(i,2) = vals{2}{voiceType(i)}(1);
    noteMean2(i,3) = vals{1}{voiceType(i)}(1);
    noteCovar2(i,1) = vals{2}{voiceType(i)}(2);
    noteCovar2(i,2) = vals{2}{voiceType(i)}(2);
    noteCovar2(i,3) = vals{1}{voiceType(i)}(2);
end

for i = 1 : numVoice
    versions{i}=nchoosek(1:numVoice,i);
end

for nVoice = 1:length(versions)
    for iVer = 1 : size(versions{nVoice},1)
        nMean1 = noteMean1(versions{nVoice}(iVer,:),:);
        nMean2 = noteMean2(versions{nVoice}(iVer,:),:);
        nVar1 = noteCovar1(versions{nVoice}(iVer,:),:);
        nVar2 = noteCovar2(versions{nVoice}(iVer,:),:);
        notes2 = cat(1, notes{nVoice}{:})';
        for v = 1 : nVoice
            meansSeed{nVoice}{iVer}(2*v-1,:) = nMean1(v,notes2(v,:));
            meansSeed{nVoice}{iVer}(2*v,:) = nMean2(v,notes2(v,:));
            covarsSeed{nVoice}{iVer}(2*v-1,2*v-1,:) = nVar1(v,notes2(v,:));
            covarsSeed{nVoice}{iVer}(2*v,2*v,:) = nVar2(v,notes2(v,:));
        end
    end
end