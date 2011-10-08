function [allstate,selectstate,spec,yinres]=runAlignment(filename, midiname, numNotes, stateOrd2, noteNum, means, covars, learnparams)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [allstate selectstate spec yinres]=seeAlignment(audiofile,midifile,...
% numNotes, stateOrd, noteNum, means, covars,learnparams)
%
% Description: 
%  Calls the DTW alignment function and refines the results with the HMM 
%  alignment algorithm, with both a basic and modified state spaces (based 
%  on the lyrics). This function returns the results of both the state
%  spaces as well as the YIN analysis of the specified audio file.
%
% Inputs:
%  filename - name of audio file
%  midiname - name of MIDI file
%  numNotes - number of notes in the MIDI file to be aligned
%  stateOrd2 - vector of state sequence
%  noteNum - vector of note numbers corresponding to state sequence
%  means - mean values for each state
%  covars - covariance values for each state
%  learnparams - flag as to whether to learn means and covars in the HMM
%
% Outputs: 
%  allstate - ending times for each state
%  selectstate - ending times for each state
%  spec - spectogram of the audio file
%  yinres - structure of results of funning the YIN algorithm on the 
%           audio signal indicated by the input variable filename
%
% Automatic Music Performance Analysis and Analysis Toolkit (AMPACT) 
% http://www.ampact.org
% (c) copyright 2011 Johanna Devaney (j@devaney.ca), all rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('learnparams', 'var'), learnparams = 0; end

% refine stateOrd2 to correspond to the number of states specified 
% in numStates
numStates = max(find(noteNum <= numNotes));
stateOrd2=stateOrd2(1:numStates);
noteNum=noteNum(1:numStates);

% read audio file and perform DTW alignment and YIN analysis
hop = 32;
[audiofile, sr] = wavread(filename);

% normalize audio file
audiofile=audiofile/sqrt(mean(audiofile.^2))*.6;
 
%get vals
[align, yinres, spec] = getVals(filename, midiname, audiofile, sr, hop);
clear audiofile

% run HMM alignment with the full state sequence
[vpath,startingState,prior,trans,meansFull,covarsFull,mixmat,obs,stateOrd] = runHMMAlignment(numNotes, means, covars, align, yinres, sr, learnparams);

% tally of the number of frames in each state
histvals = hist(vpath, 1:max(vpath));

% ending time of each state in seconds 
cumsumvals = cumsum(histvals*hop/sr);

% run HMM alignment with the state sequence refined, based on the lyrics
cumsumvals2=selectStates(startingState,prior,trans,meansFull,covarsFull,mixmat,obs,stateOrd2,noteNum,sr);

% create 3*N matrices of the alignments, where the first row is the
% current states, the second row is the time which the state ends, and
% the third row is the state index and N is the total number of states
allstate=stateOrd;
allstate(2,1:length(cumsumvals))=cumsumvals;
selectstate=stateOrd2;
selectstate(2,1:length(cumsumvals2))=cumsumvals2;
selectstate(3,:) = noteNum;