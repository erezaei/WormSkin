%%% Sylvia Fechner
%%% Stanford University, 
%%% 20171207
%%% Script to Do Noise-Analysis data from FALCON recordings in Displacement Clamp
%%% To commit to github
%%% go to my branch (patchmaster functions on dropbox)
%%% git add .
%%% git commit -m 'text'
%%% git push origin my branch

%%% ToDo 
%%  load dat.files 
clear all; close all; clc;
ephysData=ImportPatchData();
%import function from Samata Katta
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
name = 'STF136'; % name of recording. placed into varaibel fiels names%
stimuli = 'SixteenStep'; 
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

[ActuSensor, fs,interval, Time, Aall, Ball, Call, Dall, Files, isSixteenStep, isFiveStep, isFiveRamp, isStep, isFiveSine, isFifteenStep, isIVStep, isFivePosStep] = SortFalconData(name,stimuli,ephysData, ReadFromSheet);

[SlopeActu,MaxZeroSlopeActu,StdZeroSlopeActu,MaxZeroActu,StdZeroActu,MaxActuSensorPlateau,StdActuSensorPlateau,CellMaxActuFirst] = SlopeThreshold(ActuSensor);  

 %CellMaxActuFirst(i) = find([ActuSensor(:,i)] == MaxActuSensorOn(i),1,'first'); 

 StartBase = [];
   BelowPlateau  =[];
 StartBase = MaxZeroSlopeActu + 8*StdZeroSlopeActu;
 BelowPlateau  = (MaxZeroSlopeActu + 8*StdZeroSlopeActu)*-1;%changed Below Plateau calculations
 
%calculate threshold (needed to determine the Onset (Start) of the Stimulus)
% StartBase = [];
% if isFiveStep == 1 || isStep == 1 || isFifteenStep == 1 || isIVStep == 1;
%    StartBase = MaxZeroActu + 4*StdZeroActu;   %% play around and modifz 
% else
%    StartBase = MaxZeroSlopeActu + 4*StdZeroSlopeActu; %
% end

 CellSlopeActuFirst = [];
 CellSlopeActuLast = [];
 for i = 1:size(ActuSensor,2);
CellSlopeActuFirst(i) = find([SlopeActu(:,i)] > StartBase(i),1,'first');
 CellSlopeActuLast(i) = find([SlopeActu(:,i)] <   BelowPlateau(i),1,'first');
 end

%%%%%% CurrentSignals %%%%%%%
[LeakA, ASubtract, AvgMaxCurrent,AvgMaxCurrentMinus,AvgMaxCurrentOff,AvgMaxCurrentMinusOff,Start,StartOffBelow,Ende,EndeOff,ASubtractAvg,LengthRamp,LengthInms,EndeRamp,StartOffBelowShort,ActuSensorAvg] = AnalyzeCurrent(CellSlopeActuFirst,CellSlopeActuLast, isFiveSine, isFiveStep,isStep,isFifteenStep,ActuSensor,StartBase,Aall,fs,SlopeActu,BelowPlateau,CellMaxActuFirst,interval,isFivePosStep,isSixteenStep);


% modify for RampAndHold
LengthInms
LengthRamp

% calculate in pA
AverageMaxCurrentMinusppA = AvgMaxCurrentMinus*10^12;  ASubtractppA = ASubtract*10^12; % current in pA to visualize easier in subplot
AallppA=Aall*10^12; 


%%%%%% ForceClampSignals %%%%%%%

% to get Deflection of Cantilever: multiply with Sensitivity 
% get Sensitivity from Notes Day of Recording  
FindRowStiff = strcmpi(raw,name); % name = recorded cell
[Stiffrow,col] = find(FindRowStiff,1); % Siffrow: row correasponding to recorded cell

headers = raw(1,:);
ind = find(strcmpi(headers, 'Sensitivity(um/V)')); % find col with Sensitivity
Sensitivity = raw(Stiffrow,ind); 
Sensitivity = cell2mat(Sensitivity);

indStiffness = find(strcmpi(headers, 'Stiffness (N/m)'));
Stiffness = raw(Stiffrow,indStiffness); 
Stiffness = cell2mat(Stiffness);


[ActuSetPoint,CantiDefl,MeanIndentation,Force,MeanForce,Indentation,normCantiDefl,allRiseTime,allOvershoot] = AnalyzeForceClamp(interval,Start,isFiveStep,isStep,isFifteenStep,Dall,Call,EndeOff,ActuSensor,Sensitivity,Stiffness,fs,isSixteenStep);

%% now figures
close all
xScatter = (1:length(MeanIndentation));
LengthInmsForPlot = LengthInms*1000;

%%%current with and without leak subtraction in a subplot %%%%
if OnlyMechano  == 0;
figure()
for i = 1:size(AallppA,2)
subplot(ceil(size(AallppA,2)/5),5,i)
plot(Time,AallppA(:,i))
%ylim([-5*10^-11 1*10^-11])
hold on
plot(Time,ASubtractppA(:,i))
%RecNum = i; % include number of i within legend or title to easier
%determine the position of the plot
if isFiveStep == 1 || isStep == 1 || isFifteenStep == 1 || isSixteenStep == 1;
title(round(MeanIndentation(i),1)) %% 
else
    title(round(LengthInmsForPlot(i),1)) 
end
end
suptitle({'Current (pA) with (red) and without (blue) leak subtraction';'Bold numbers: Indentation in µm'}) %('')
elseif OnlyMechano  == 1;
    'hello mechano'
end
%%%cantilever signals %%%%


figure()
for i = 1:size(Aall,2)
subplot(ceil(size(AallppA,2)/5),5,i)
plot(Time,CantiDefl(:,i))
%ylim([-5*10^-11 1*10^-11])
%RecNum = i; % include number of i within legend or title to easier
%determine the position of the plot
if isFiveStep == 1 || isStep == 1 || isFifteenStep == 1|| isSixteenStep == 1;
title(round(MeanIndentation(i),1)) %% 
else
    title(round(LengthInmsForPlot(i),1)) 
end
end
suptitle({'Cantilever Deflection'}) %('')



%%%normalized cantilever signals %%%%
figure()
for i = 1:size(Aall,2)
subplot(ceil(size(AallppA,2)/5),5,i)
plot(Time,ActuSensor(:,i))
ylim([-1 16])
%ylim([-5*10^-11 1*10^-11])
%RecNum = i; % include number of i within legend or title to easier
%determine the position of the plot
if isFiveStep == 1 || isStep == 1|| isFifteenStep == 1 || isSixteenStep == 1;
title(round(MeanIndentation(i),1)) %% 
else
    title(round(LengthInmsForPlot(i),1)) 
end
end
suptitle({'Actuator Sensor'}) %('')

%control plot

figure()
subplot(3,2,1)
scatter(xScatter, Start) 
%ylim([0 1000]) % ToDo: change it for Ramps
ylabel('Point')
xlabel('Filenumber')
title('control: Find OnSet of On-Stimulus')
hold on 
subplot(3,2,2)
scatter(xScatter, StartOffBelow) %change to start of below
%ylim([100 1000]) % ToDo: change it for Ramps
ylabel('Point')
xlabel('Filenumber')
title('control: Find OnSet of Off-Stimulus')
hold on 
subplot(3,2,3)
scatter(xScatter, LengthInmsForPlot) %change to start of below
%ylim([100 1000]) % ToDo: change it for Ramps
ylabel('Lengtg of OnSet Stimulus (ms)')
xlabel('Filenumber')
title('Length of Ramp')
subplot(3,2,4)
scatter(xScatter, AverageMaxCurrentMinusppA ) %change to start of below
%ylim([100 1000]) % ToDo: change it for Ramps
ylabel('Current (pA)')
xlabel('Filenumber')
title('control: compare Max current of each stimulus with traces')


%% delete single recordings 
%close all
%ToDo: has to be changed for ramps, because I want to average the current with
%same velocity 

ASubtractNew = ASubtract; %ASubtractAvg;
AvgMaxCurrentMinusNew = AvgMaxCurrentMinus;
MeanIndentationNew = MeanIndentation;
LeakANew = LeakA;
%AverageMaxNormCurrentNew = 
%TO DO: Someting wrong with the order in command promt
% if I redo AverageMaxCurrentMinus= Nan, I have to reload it again or do it
% as for ASubtract new

while 1
prompt = {'Enter number of recording, matches subplot (leave empty to quit, enter a number as long as you want to delete a recording)'};%,'SecondRec','ThirdRec','ForthRec'};
dlg_title = 'Delete a recording?';
num_lines = 1;
defaultans = {''};%,'','',''};
IndValues = inputdlg(prompt,dlg_title,num_lines,defaultans);
FirstRec = str2num(IndValues{1});
%SecondRec = str2num(IndValues{2});
%ThirdRec = str2num(IndValues{3});
%ForthRec = str2num(IndValues{3});

if isempty(FirstRec) == 1
    break
else
  ASubtractNew(:,FirstRec) = NaN;
  AvgMaxCurrentMinusNew(FirstRec) = NaN;
  MeanIndentationNew(:,FirstRec) = NaN;
  LeakANew(:,FirstRec) = NaN;
  
end
end

AvgMaxCurrentMinusNewppA = AvgMaxCurrentMinusNew*10^12;
LeakAppA = LeakANew*10^12;

%% running Avg 8 MRCs

RunAvgofEight = [];
for i=1:4:size(ASubtractNew,2)-4%size(ASubtractNew,2)-4
RunAvgofEight(:,floor(i/4)+1) = nanmean(ASubtractNew(:,i:i+7),2);
end

 VarOfEight = [];
 AvgMean = [];
 sub = [];
 AvgOfEight = [];
 AvgVar = [];
AllVarOfEight = [];

    for i =1:4:size(ASubtractNew,2)-4
       AvgOfEight = [];
       AvgOfEight = nanmean(ASubtractNew(:,i:i+7),2);
         sub = [];
       for j=0:7
       sub(:,j+1) = (ASubtractNew(:,j+i)-AvgOfEight).^2;
       end
       VarOfEight = sum(sub,2)/7;
       AllVarOfEight(:,floor(i/4)+1) = VarOfEight;
    end
    
      AvgVar = nanmean(AllVarOfEight,2);
      AvgMean = nanmean(RunAvgofEight,2);
      
     ConcatMean = [];
     ConcatMean = vertcat(RunAvgofEight(Start-300:Start+1000,:));
     ConcatMean2 = [];
     ConcatMean2 = vertcat(ConcatMean(:));
     ConcatVar = [];
     ConcatVar = vertcat(AllVarOfEight(Start-300:Start+1000,:));
     ConcatVar2 = [];
    ConcatVar2 = vertcat(ConcatVar (:));
     ShortAvg = [];
     ShortAvg = AvgMean(Start-300:Start+1000,:)
     ShortVar = [];
     ShortVar = AvgVar(Start-300:Start+1000,:)
     
     figure()
     plot(ShortAvg)
     figure()
     plot(ShortVar)
      


%%
figure()
plot(RunAvgofEight)
figure()
plot(AllVarOfEight)
figure()
plot(AvgVar)




