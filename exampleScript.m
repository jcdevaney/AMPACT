%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% exampleScript.m
%
% Description: 
%   Example of how to use the HMM alignment algorithm
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You will need to have the following toolkits installed and in your path
%  de Cheveigné, A. 2002. YIN MATLAB implementation Available from:
%    http://audition.ens.fr/adc/sw/yin.zip
%  Ellis, D. P. W. 2003. Dynamic Time Warp (DTW) in Matlab. Available 
%   from: http://www.ee.columbia.edu/~dpwe/resources/matlab/dtw/ 
%  Ellis, D. P. W. 2008. Aligning MIDI scores to music audio. Available 
%   from: http://www.ee.columbia.edu/~dpwe/resources/matlab/alignmidiwav/ 
%  Murphy, K. 1998. Hidden Markov Model (HMM) Toolbox for Matlab.
%    Available from http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html 
% Genesis Acoustics. 2010. Loudness Toolbox for Matlab.
%    Available from http://www.genesis-acoustics.com/index.php?page=32  
% Toiviainen, P. and T. Eerola. 2006. MIDI Toolbox. Available from:
%   https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials
%          /miditoolbox/
%
% http://www.genesis-acoustics.com/cn/index.php?page=32
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% audio file to be aligned
audiofile=('example.wav');

% MIDI file to be aligned
midifile=('example.mid');

% number of notes to align
numNotes=6;

% vector of order of states (according to lyrics) in stateOrd and 
% corresponding note numbers in noteNum
%   1 indicates a rest at the beginning of ending of the note
%   2 indicates a transient at the beginning or ending of the note
%   3 indicates a steady state section
% the following encoding is for six syllables "A-ve Ma-ri-(i)-a"
%  syllable      A-ve Ma-ri-(i)-a
%  state type   13 23 23 23  3  31
%  note number  11 22 33 44  5  66
stateOrd  = [1 3 2 3 2 3 2 3 3 3 1];
noteNum =   [1 1 2 2 3 3 4 4 5 6 6];

% load singing means and covariances for the HMM alignment
load SingingMeansCovars.mat
means=sqrtmeans; 
covars=sqrtcovars;

% specify that the means and covariances in the HMM won't be learned 
learnparams=0;

% run the alignment
[allstate selectstate,spec,yinres]=runAlignment(audiofile, midifile, numNotes, stateOrd, noteNum, means, covars, learnparams);

% visualise the alignment
alignmentVisualiser(selectstate,midifile,spec,1);

% get onset and offset times
times=getOnsOffs(selectstate);

% write the onset and offset times to an audacity-readable file
dlmwrite('example.txt',[times.ons' times.offs'], 'delimiter', '\t');

% you can load 'example.txt' into audacity and correct any errors in the
% alignment, i.e., the offset error on the last note, and then reload the
% corrected labels into matlab
fixedLabels=load('exampleFixed.txt');
times.ons=fixedLabels(:,1)';
times.offs=fixedLabels(:,2)';

% map timing information to the quantized MIDI file   
nmatNew=getTimingData(midifile, times);
% Note: writemidi function from the MIDI Toolkit only works on Power PC
% processors
writemidi(nmatNew,'examplePerformance.mid')

% get cent values for each note
cents=getCentVals(times,yinres);

% calculate intervals size, perceived pitch, vibrato rate, and vibrato depth
[vibratoDepth, vibratoRate, intervalSize, perceivedPitch]=getPitchVibratoData(cents,yinres.sr); 

% get loudness values for each note using the Genesis Loudness Toolbox
[loudnessEstimates loudnessStructure]=getLoudnessEstimates(audiofile, times);

% get DCT values for each note
for i = 1 : length(cents)
    
    % find the peaks and troughs in the F0 trace for each note
    [mins{i} maxes{i}] = findPeaks(cents{i}, 100, yinres.sr/32, 60);
    
    % find the midpoints between mins and maxes in the F0 trace for each
    % note
    [x_mids{i} y_mids{i}] = findMids(cents{i}, mins{i}, maxes{i}, 100, yinres.sr/32);
    
    % generate a smoothed trajectory of a note by connecting the
    % midpoints between peaks and troughs.
    smoothedF0s{i}=smoothNote(cents{i}, x_mids{i}, y_mids{i});
    
    % find the steady-state portion of a note
    steady{i}(1:2)=findSteady(cents{i}, mins{i}, maxes{i}, x_mids{i}, y_mids{i}, 1);
    
    % compute the DCT of a signal and approximate it with the first 
    % 3 coefficients
    [dctVals{i}, approx{i}]=noteDct(smoothedF0s{i}(steady{i}(1):steady{i}(2)),3,yinres.sr/32);

end
