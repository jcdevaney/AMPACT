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
%   Murphy, K. 1998. Hidden Markov Model (HMM) Toolbox for Matlab.
%    Available from http://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html 
%  Toiviainen, P. and T. Eerola. 2006. MIDI Toolbox. Available from:
%   https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials
%          /miditoolbox/
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

% map timing information to the quantized MIDI file   
nmatNew=getTimingData(midifile, times);

% calculate intervals size, perceived pitch, vibrato rate, vibrato depth, and loudness
[vibratoDepth, vibratoRate, noteDynamics, intervalSize, pp,nmatNew]=getPitchVibratoDynamicsData(times,yinres,nmatNew); 