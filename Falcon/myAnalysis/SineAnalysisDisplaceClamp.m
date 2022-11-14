%%% Sylvia Fechner
%%% Stanford University, 
%%% 20171207
%%% Script to analyze data from FALCON-Sinus recordings in Displacement Clamp
%%% To commit to github
%%% go to my branch (patchmaster functions on dropbox)
%%% git add .
%%% git commit -m 'text'
%%% git push origin my branch


%%% ToDo 

%%  load dat.files 
clear all; close all; clc;
ephysData=ImportPatchData();
%load('ephysdata(20170130).mat')
%%
% load notes to get several values automatically needed for the conversion of the signals
loadFileMode = 1; % change here, if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('Ephys-Meta-Sylvia.xlsx'); % be careful in which Folder saved.
end


%% Analysis Individual Recording 
close all; clc

%%% hardcoding part:
name = 'STF118'; % name of recording. placed into varaibel fiels names%
stimuli = 'FiveSine'; 
OnlyMechano = 0; % if = 0, then FALCON, if 1, then ForceClamp Only 
ReadFromSheet = 0; % if = 0, then command promp to delete block, if 1, then read from MetaDataSheet 
% protocol names:
% Single protocols: Step and Ramp-Hold; 
% Five sweeps per protocol:FiveStep, FiveRampHold; does not work with alternative names
%%%%%

%Aall = current
%Ball = Actuator
%Call = Cantilever
%Dall = ActuatorSetpoint

[ActuSensor, fs,interval, Time, Aall, Ball, Call, Dall, Files, isSixteenStep, isFiveStep, isFiveRamp, isStep, isFiveSine, isFifteenStep, isIVStep] = SortFalconData(name,stimuli,ephysData, ReadFromSheet);

[SlopeActu,MaxZeroSlopeActu,StdZeroSlopeActu,MaxZeroActu,StdZeroActu,MaxActuSensorPlateau,StdActuSensorPlateau,CellMaxActuFirst] = SlopeThreshold(ActuSensor);  

 %CellMaxActuFirst(i) = find([ActuSensor(:,i)] == MaxActuSensorOn(i),1,'first'); 

%calculate threshold (needed to determine the Onset (Start) of the Stimulus)
StartBase = [];
if isFiveStep == 1 || isStep == 1 || isFifteenStep == 1 || isIVStep == 1;
   StartBase = MaxZeroActu + 4*StdZeroActu;   %% play around and modifz 
else
   StartBase = MaxZeroSlopeActu + 4*StdZeroSlopeActu; %
end

%calculate beginning and end of sine function (if no other stimuli is
%present
CellSlopeActuFirst = [];
CellSlopeActuLast = [];
for i = 1:size(ActuSensor,2);
CellSlopeActuFirst(i) = find([ActuSensor(:,i)] > StartBase(i),1,'first')
CellSlopeActuLast(i) = find([ActuSensor(:,i)] > StartBase(i),1,'last')
end


%[LeakA, ASubtract, AvgMaxCurrent,AvgMaxCurrentMinus,AvgMaxCurrentOff,AvgMaxCurrentMinusOff,Start,StartOffBelow,Ende,EndeOff,ASubtractAvg,LengthRamp,LengthInms,EndeRamp,StartOffBelowShort,ActuSensorAvg] = AnalyzeCurrent(CellSlopeActuFirst,CellSlopeActuLast, isFiveSine, isFiveStep,isStep,isFifteenStep,ActuSensor,StartBase,Aall,fs,SlopeActu,BelowPlateau,CellMaxActuFirst,interval);

%%
Fs = fs;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1500;             % Length of signal
t = (0:L-1)*T;        % Time vector

Y = fft(Aall(:,4));

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1)

f = Fs*(0:(L/2))/L;
figure()
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

%%
figure()
plot(Time, Aall(:,1))
figure()
plot(Aall(:,2))
figure()
plot(Aall(:,3))
figure()
plot(Aall(:,4))
figure()
plot(SlopeActu(:,2))

